<template>
  <header class="site-header">
    <div class="header-inner container">
      <a class="brand" href="#catalog" aria-label="The Art — на главную">
        <svg viewBox="0 0 44 44" aria-hidden="true"><path d="M22 2 42 22 22 42 2 22 22 2Zm0 7L9 22l13 13 13-13L22 9Zm0 5 8 8-8 8-8-8 8-8Z" /></svg>
        <span>THE ART</span>
      </a>
      <nav :class="['nav', { 'nav--open': menuOpen }]" aria-label="Главная навигация">
        <a href="#catalog" @click="closeMenu">Каталог</a>
        <a href="#delivery" @click="closeMenu">Доставка</a>
        <a href="#payment" @click="closeMenu">Оплата</a>
        <a href="#contacts" @click="closeMenu">Контакты</a>
      </nav>
      <form class="search" role="search" @submit.prevent>
        <label class="sr-only" for="art-search">Поиск по названию картины</label>
        <input id="art-search" :value="query" type="search" placeholder="Поиск по названию картины" autocomplete="off" @input="$emit('update:query', $event.target.value)" />
        <button type="submit" aria-label="Найти">Найти</button>
      </form>
      <button class="menu-button" type="button" :aria-expanded="String(menuOpen)" aria-label="Открыть меню" @click="$emit('update:menuOpen', !menuOpen)">
        <span></span><span></span><span></span>
      </button>
    </div>
  </header>
</template>

<script>
export default {
  name: "SiteHeader",
  props: { query: { type: String, default: "" }, menuOpen: { type: Boolean, default: false } },
  methods: { closeMenu() { this.$emit("update:menuOpen", false); } },
};
</script>
