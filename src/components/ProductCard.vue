<template>
  <article :class="['product-card', { 'product-card--sold': product.sold }]">
    <button
      class="product-image"
      type="button"
      :aria-label="`Открыть описание: ${product.title}`"
      @click="$emit('open', product)"
    >
      <img
        :src="product.image"
        :alt="product.title"
        :style="{ objectPosition: product.position }"
      />
      <span class="image-overlay">Смотреть подробнее</span>
    </button>
    <div class="product-content">
      <button
        class="product-title"
        type="button"
        @click="$emit('open', product)"
      >
        «{{ product.title }}»<br /><span>{{ product.author }}</span>
      </button>
      <div
        :class="['buy-row', { 'buy-row--processing': status === 'processing' }]"
      >
        <div class="price">
          <del v-if="product.oldPrice">{{ product.oldPrice }}</del
          ><strong>{{ product.price }}</strong>
        </div>
        <button
          v-if="!product.sold"
          :class="['buy-button', `buy-button--${status}`]"
          type="button"
          :disabled="status !== 'idle'"
          @click="$emit('buy', product)"
        >
          <template v-if="status === 'processing'"
            ><span class="spinner" aria-hidden="true"></span
            ><span>Обрабатывается</span></template
          >
          <template v-else-if="status === 'cart'"
            ><svg viewBox="0 0 24 24" aria-hidden="true">
              <path d="m5 12 4 4L19 6" /></svg
            ><span>В корзине</span></template
          >
          <span v-else>Купить</span>
        </button>
      </div>
    </div>
  </article>
</template>

<script>
export default {
  name: "ProductCard",
  props: {
    product: { type: Object, required: true },
    status: { type: String, default: "idle" },
  },
};
</script>

<style scoped>
.product-card {
  min-width: 0;
  background: var(--card);
  border: 1px solid var(--line);
  transition: box-shadow 0.25s ease, transform 0.25s ease;
}
.product-card:hover {
  z-index: 1;
  box-shadow: 0 18px 42px rgba(60, 46, 40, 0.12);
  transform: translateY(-3px);
}
.product-image {
  position: relative;
  display: block;
  width: 100%;
  height: 178px;
  padding: 0;
  overflow: hidden;
  background: #d5c9bd;
  border: 0;
  cursor: pointer;
}
.product-image img {
  width: 100%;
  height: 100%;
  display: block;
  object-fit: cover;
  transition: transform 0.55s ease, filter 0.3s ease;
}
.product-image:hover img {
  transform: scale(1.045);
  filter: brightness(0.7);
}
.image-overlay {
  position: absolute;
  inset: auto 0 0;
  padding: 18px;
  color: #fff;
  background: linear-gradient(transparent, rgba(25, 18, 16, 0.78));
  font: 700 12px "Merriweather", Georgia, serif;
  letter-spacing: 0.06em;
  opacity: 0;
  transform: translateY(8px);
  transition: 0.3s ease;
}
.product-image:hover .image-overlay {
  opacity: 1;
  transform: translateY(0);
}
.product-content {
  min-height: 166px;
  padding: 20px 22px 24px;
  display: flex;
  flex-direction: column;
}
.product-title {
  padding: 0;
  color: var(--ink);
  background: transparent;
  border: 0;
  text-align: left;
  font-size: 18px;
  font-weight: 400;
  line-height: 1.45;
  cursor: pointer;
}
.product-title span {
  font-size: 15px;
}
.product-title:hover {
  color: #79574d;
}
.buy-row {
  margin-top: auto;
  padding-top: 22px;
  display: grid;
  grid-template-columns: minmax(0, 1fr) auto;
  align-items: center;
  gap: 10px;
  min-height: 48px;
}
.buy-row--processing {
  grid-template-columns: 1fr;
  align-items: stretch;
}
.buy-row--processing .buy-button {
  width: 100%;
  margin-left: 0;
}
@media (max-width: 1200px) {
  .product-image {
    height: 230px;
  }
}
@media (max-width: 780px) {
  .product-image {
    height: 185px;
  }
}
@media (max-width: 620px) {
  .product-image {
    height: min(62vw, 235px);
  }
  .product-content {
    min-height: 150px;
  }
  .product-title {
    font-size: 19px;
  }
}
</style>
