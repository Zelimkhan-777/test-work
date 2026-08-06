<template>
  <transition name="modal">
    <div v-if="selected" class="modal-backdrop" @mousedown.self="close" @click.self="close">
      <section ref="modal" class="modal-card" role="dialog" aria-modal="true" :aria-labelledby="`modal-title-${selected.id}`" :aria-describedby="`modal-description-${selected.id}`">
        <button ref="closeButton" class="modal-close" type="button" aria-label="Закрыть" @click="close">×</button>
        <div class="slider">
          <div class="slide-stage">
            <img :src="selected.images[slideIndex].src" :alt="`${selected.title}: ${selected.images[slideIndex].label}`" />
            <span class="slide-label">{{ selected.images[slideIndex].label }}</span>
            <button class="slider-arrow slider-arrow--prev" type="button" aria-label="Предыдущее изображение" @click="prevSlide">‹</button>
            <button class="slider-arrow slider-arrow--next" type="button" aria-label="Следующее изображение" @click="nextSlide">›</button>
          </div>
          <div class="slider-dots" aria-label="Выбор изображения">
            <button v-for="(slide, index) in selected.images" :key="index" type="button" :class="{ active: slideIndex === index }" :aria-current="slideIndex === index ? 'true' : null" :aria-label="slide.label" @click="slideIndex = index"></button>
          </div>
        </div>
        <div class="modal-info">
          <p class="eyebrow">Шедевр коллекции</p>
          <h2 :id="`modal-title-${selected.id}`">«{{ selected.title }}»</h2>
          <p class="modal-author">{{ selected.author }}, {{ selected.year }}</p>
          <p :id="`modal-description-${selected.id}`" class="modal-description">{{ selected.description }}</p>
          <div class="modal-meta"><span>Техника</span><strong>{{ selected.technique }}</strong></div>
          <div class="modal-meta"><span>Размер</span><strong>{{ selected.size }}</strong></div>
          <div :class="['modal-purchase', { 'modal-purchase--processing': status === 'processing' }]">
            <div class="price price--modal"><del v-if="selected.oldPrice">{{ selected.oldPrice }}</del><strong>{{ selected.price }}</strong></div>
            <button v-if="!selected.sold" :class="['buy-button', `buy-button--${status}`]" type="button" :disabled="status !== 'idle'" @click="$emit('buy', selected)">
              <template v-if="status === 'processing'"><span class="spinner"></span><span>Обрабатывается</span></template>
              <template v-else-if="status === 'cart'"><svg viewBox="0 0 24 24"><path d="m5 12 4 4L19 6" /></svg><span>В корзине</span></template>
              <span v-else>Купить</span>
            </button>
          </div>
        </div>
      </section>
    </div>
  </transition>
</template>

<script>
export default {
  name: "ProductModal",
  props: { selected: { type: Object, default: null }, status: { type: String, default: "idle" } },
  data() { return { slideIndex: 0 }; },
  watch: {
    selected(value) {
      if (value) { this.slideIndex = 0; this.$nextTick(() => this.$refs.closeButton && this.$refs.closeButton.focus()); }
    },
  },
  mounted() { document.addEventListener("keydown", this.onKeydown); },
  beforeDestroy() { document.removeEventListener("keydown", this.onKeydown); },
  methods: {
    close() { this.$emit("close"); },
    prevSlide() { this.slideIndex = (this.slideIndex - 1 + this.selected.images.length) % this.selected.images.length; },
    nextSlide() { this.slideIndex = (this.slideIndex + 1) % this.selected.images.length; },
    onKeydown(event) {
      if (!this.selected) return;
      if (event.key === "Escape") { event.preventDefault(); this.close(); return; }
      if (event.key !== "Tab" || !this.$refs.modal) return;
      const focusable = Array.from(this.$refs.modal.querySelectorAll('a[href], button:not([disabled]), input:not([disabled]), [tabindex]:not([tabindex="-1"])'));
      if (!focusable.length) return;
      const first = focusable[0]; const last = focusable[focusable.length - 1];
      if (event.shiftKey && document.activeElement === first) { event.preventDefault(); last.focus(); }
      else if (!event.shiftKey && document.activeElement === last) { event.preventDefault(); first.focus(); }
    },
  },
};
</script>
