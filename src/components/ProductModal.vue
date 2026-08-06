<template>
  <transition name="modal">
    <div
      v-if="selected"
      class="modal-backdrop"
      @mousedown.self="close"
      @click.self="close"
    >
      <section
        ref="modal"
        class="modal-card"
        role="dialog"
        aria-modal="true"
        :aria-labelledby="`modal-title-${selected.id}`"
        :aria-describedby="`modal-description-${selected.id}`"
      >
        <button
          ref="closeButton"
          class="modal-close"
          type="button"
          aria-label="Закрыть"
          @click="close"
        >
          ×
        </button>
        <div class="slider">
          <div class="slide-stage">
            <img
              :src="selected.images[slideIndex].src"
              :alt="`${selected.title}: ${selected.images[slideIndex].label}`"
            />
            <span class="slide-label">{{
              selected.images[slideIndex].label
            }}</span>
            <button
              class="slider-arrow slider-arrow--prev"
              type="button"
              aria-label="Предыдущее изображение"
              @click="prevSlide"
            >
              ‹
            </button>
            <button
              class="slider-arrow slider-arrow--next"
              type="button"
              aria-label="Следующее изображение"
              @click="nextSlide"
            >
              ›
            </button>
          </div>
          <div class="slider-dots" aria-label="Выбор изображения">
            <button
              v-for="(slide, index) in selected.images"
              :key="index"
              type="button"
              :class="{ active: slideIndex === index }"
              :aria-current="slideIndex === index ? 'true' : null"
              :aria-label="slide.label"
              @click="slideIndex = index"
            ></button>
          </div>
        </div>
        <div class="modal-info">
          <p class="eyebrow">Шедевр коллекции</p>
          <h2 :id="`modal-title-${selected.id}`">«{{ selected.title }}»</h2>
          <p class="modal-author">{{ selected.author }}, {{ selected.year }}</p>
          <p :id="`modal-description-${selected.id}`" class="modal-description">
            {{ selected.description }}
          </p>
          <div class="modal-meta">
            <span>Техника</span><strong>{{ selected.technique }}</strong>
          </div>
          <div class="modal-meta">
            <span>Размер</span><strong>{{ selected.size }}</strong>
          </div>
          <div
            :class="[
              'modal-purchase',
              { 'modal-purchase--processing': status === 'processing' },
            ]"
          >
            <div class="price price--modal">
              <del v-if="selected.oldPrice">{{ selected.oldPrice }}</del
              ><strong>{{ selected.price }}</strong>
            </div>
            <button
              v-if="!selected.sold"
              :class="['buy-button', `buy-button--${status}`]"
              type="button"
              :disabled="status !== 'idle'"
              @click="$emit('buy', selected)"
            >
              <template v-if="status === 'processing'"
                ><span class="spinner"></span
                ><span>Обрабатывается</span></template
              >
              <template v-else-if="status === 'cart'"
                ><svg viewBox="0 0 24 24"><path d="m5 12 4 4L19 6" /></svg
                ><span>В корзине</span></template
              >
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
  props: {
    selected: { type: Object, default: null },
    status: { type: String, default: "idle" },
  },
  data() {
    return { slideIndex: 0 };
  },
  watch: {
    selected(value) {
      if (value) {
        this.slideIndex = 0;
        this.$nextTick(
          () => this.$refs.closeButton && this.$refs.closeButton.focus(),
        );
      }
    },
  },
  mounted() {
    document.addEventListener("keydown", this.onKeydown);
  },
  beforeDestroy() {
    document.removeEventListener("keydown", this.onKeydown);
  },
  methods: {
    close() {
      this.$emit("close");
    },
    prevSlide() {
      this.slideIndex =
        (this.slideIndex - 1 + this.selected.images.length) %
        this.selected.images.length;
    },
    nextSlide() {
      this.slideIndex = (this.slideIndex + 1) % this.selected.images.length;
    },
    onKeydown(event) {
      if (!this.selected) return;
      if (event.key === "Escape") {
        event.preventDefault();
        this.close();
        return;
      }
      if (event.key !== "Tab" || !this.$refs.modal) return;
      const focusable = Array.from(
        this.$refs.modal.querySelectorAll(
          'a[href], button:not([disabled]), input:not([disabled]), [tabindex]:not([tabindex="-1"])',
        ),
      );
      if (!focusable.length) return;
      const first = focusable[0];
      const last = focusable[focusable.length - 1];
      if (event.shiftKey && document.activeElement === first) {
        event.preventDefault();
        last.focus();
      } else if (!event.shiftKey && document.activeElement === last) {
        event.preventDefault();
        first.focus();
      }
    },
  },
};
</script>

<style scoped>
.modal-backdrop {
  position: fixed;
  z-index: 20;
  inset: 0;
  padding: 28px;
  display: grid;
  place-items: center;
  background: rgba(31, 24, 22, 0.82);
  backdrop-filter: blur(3px);
}
.modal-card {
  position: relative;
  width: min(1010px, 100%);
  max-height: calc(100vh - 56px);
  overflow: auto;
  display: grid;
  grid-template-columns: 55% 45%;
  background: #f8f4f0;
  box-shadow: 0 24px 80px rgba(0, 0, 0, 0.36);
}
.modal-close {
  position: absolute;
  z-index: 3;
  top: 12px;
  right: 14px;
  width: 38px;
  height: 38px;
  color: #fff;
  background: rgba(52, 42, 39, 0.75);
  border: 1px solid rgba(255, 255, 255, 0.35);
  border-radius: 50%;
  font: 30px/32px Arial, sans-serif;
  cursor: pointer;
}
.slider {
  min-width: 0;
  background: #2b2523;
}
.slide-stage {
  position: relative;
  height: 100%;
  min-height: 570px;
  overflow: hidden;
}
.slide-stage img {
  width: 100%;
  height: 100%;
  position: absolute;
  inset: 0;
  object-fit: cover;
  object-position: center;
}
.slide-label {
  position: absolute;
  left: 22px;
  bottom: 22px;
  padding: 8px 11px;
  color: #fff;
  background: rgba(40, 30, 27, 0.7);
  font: 700 11px "Merriweather", Georgia, serif;
  letter-spacing: 0.06em;
}
.slider-arrow {
  position: absolute;
  top: 50%;
  width: 42px;
  height: 54px;
  transform: translateY(-50%);
  color: #fff;
  background: rgba(40, 30, 27, 0.55);
  border: 0;
  font: 36px/1 Arial, sans-serif;
  cursor: pointer;
}
.slider-arrow:hover {
  background: rgba(40, 30, 27, 0.8);
}
.slider-arrow--prev {
  left: 16px;
}
.slider-arrow--next {
  right: 16px;
}
.slider-dots {
  position: absolute;
  z-index: 2;
  bottom: 25px;
  left: calc(27.5% - 34px);
  display: flex;
  gap: 8px;
}
.slider-dots button {
  width: 8px;
  height: 8px;
  padding: 0;
  background: rgba(255, 255, 255, 0.45);
  border: 0;
  border-radius: 50%;
  cursor: pointer;
}
.slider-dots button.active {
  background: #fff;
  transform: scale(1.3);
}
.modal-info {
  padding: 58px 48px 42px;
  display: flex;
  flex-direction: column;
}
.modal-info h2 {
  margin: 0 0 8px;
  font-size: 34px;
  line-height: 1.18;
  font-weight: 400;
}
.modal-author {
  margin: 0 0 29px;
  color: #7e7169;
  font-size: 16px;
}
.modal-description {
  margin: 0 0 27px;
  font: 700 15px/1.75 "Merriweather", Georgia, serif;
  color: #5f5752;
}
.modal-meta {
  padding: 13px 0;
  display: flex;
  justify-content: space-between;
  gap: 22px;
  border-top: 1px solid var(--line);
  font: 700 13px "Merriweather", Georgia, serif;
}
.modal-meta span {
  color: #978b83;
}
.modal-meta strong {
  font-weight: 700;
  text-align: right;
}
.modal-purchase {
  margin-top: auto;
  padding-top: 28px;
  display: flex;
  align-items: flex-end;
  gap: 18px;
}
.modal-purchase--processing {
  align-items: stretch;
  flex-direction: column;
}
.modal-purchase--processing .buy-button {
  width: 100%;
  margin-left: 0;
}
.price--modal strong {
  font-size: 20px;
}
.price--modal del {
  font-size: 13px;
}
.modal-enter-active,
.modal-leave-active {
  transition: opacity 0.25s ease;
}
.modal-enter-active .modal-card,
.modal-leave-active .modal-card {
  transition: transform 0.25s ease;
}
.modal-enter,
.modal-leave-to {
  opacity: 0;
}
.modal-enter .modal-card,
.modal-leave-to .modal-card {
  transform: translateY(18px) scale(0.985);
}
@media (max-width: 780px) {
  .modal-card {
    grid-template-columns: 1fr;
  }
  .slide-stage {
    min-height: 330px;
    height: 45vh;
  }
  .slider-arrow--prev {
    left: 10px;
  }
  .slider-arrow--next {
    right: 10px;
  }
  .slider-dots {
    position: relative;
    left: auto;
    bottom: auto;
    height: 36px;
    align-items: center;
    justify-content: center;
  }
  .modal-info {
    padding: 34px 30px;
  }
}
@media (max-width: 620px) {
  .modal-backdrop {
    padding: 0;
    align-items: stretch;
  }
  .modal-card {
    max-height: 100vh;
    width: 100%;
  }
  .slide-stage {
    min-height: 260px;
    height: 37vh;
  }
  .modal-info {
    padding: 30px 22px 28px;
  }
  .modal-info h2 {
    font-size: 28px;
  }
  .modal-description {
    font-size: 14px;
  }
  .modal-purchase {
    align-items: stretch;
    flex-direction: column;
  }
  .modal-purchase .buy-button {
    width: 100%;
    margin-left: 0;
  }
}
</style>
