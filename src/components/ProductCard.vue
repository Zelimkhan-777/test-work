<template>
  <article :class="['product-card', { 'product-card--sold': product.sold }]">
    <button class="product-image" type="button" :aria-label="`Открыть описание: ${product.title}`" @click="$emit('open', product)">
      <img :src="product.image" :alt="product.title" :style="{ objectPosition: product.position }" />
      <span class="image-overlay">Смотреть подробнее</span>
    </button>
    <div class="product-content">
      <button class="product-title" type="button" @click="$emit('open', product)">
        «{{ product.title }}»<br /><span>{{ product.author }}</span>
      </button>
      <div :class="['buy-row', { 'buy-row--processing': status === 'processing' }]">
        <div class="price"><del v-if="product.oldPrice">{{ product.oldPrice }}</del><strong>{{ product.price }}</strong></div>
        <button v-if="!product.sold" :class="['buy-button', `buy-button--${status}`]" type="button" :disabled="status !== 'idle'" @click="$emit('buy', product)">
          <template v-if="status === 'processing'"><span class="spinner" aria-hidden="true"></span><span>Обрабатывается</span></template>
          <template v-else-if="status === 'cart'"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="m5 12 4 4L19 6" /></svg><span>В корзине</span></template>
          <span v-else>Купить</span>
        </button>
      </div>
    </div>
  </article>
</template>

<script>
export default {
  name: "ProductCard",
  props: { product: { type: Object, required: true }, status: { type: String, default: "idle" } },
};
</script>
