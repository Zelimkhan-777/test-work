<template>
  <header class="site-header">
    <div class="header-inner container">
      <a class="brand" href="#catalog" aria-label="The Art — на главную">
        <svg viewBox="0 0 44 44" aria-hidden="true">
          <path
            d="M22 2 42 22 22 42 2 22 22 2Zm0 7L9 22l13 13 13-13L22 9Zm0 5 8 8-8 8-8-8 8-8Z"
          />
        </svg>
        <span>THE ART</span>
      </a>
      <nav
        :class="['nav', { 'nav--open': menuOpen }]"
        aria-label="Главная навигация"
      >
        <a href="#catalog" @click="closeMenu">Каталог</a>
        <a href="#delivery" @click="closeMenu">Доставка</a>
        <a href="#payment" @click="closeMenu">Оплата</a>
        <a href="#contacts" @click="closeMenu">Контакты</a>
        <a href="#about" @click="closeMenu">О компании</a>
      </nav>
      <form class="search" role="search" @submit.prevent>
        <label class="sr-only" for="art-search"
          >Поиск по названию картины</label
        >
        <input
          id="art-search"
          :value="query"
          type="search"
          placeholder="Поиск по названию картины"
          autocomplete="off"
          @input="$emit('update:query', $event.target.value)"
        />
        <button type="submit" aria-label="Найти">Найти</button>
      </form>
      <button
        class="menu-button"
        type="button"
        :aria-expanded="String(menuOpen)"
        aria-label="Открыть меню"
        @click="$emit('update:menuOpen', !menuOpen)"
      >
        <span></span><span></span><span></span>
      </button>
    </div>
  </header>
</template>

<script>
export default {
  name: "SiteHeader",
  props: {
    query: { type: String, default: "" },
    menuOpen: { type: Boolean, default: false },
  },
  methods: {
    closeMenu() {
      this.$emit("update:menuOpen", false);
    },
  },
};
</script>

<style scoped>
.site-header {
  min-height: 96px;
  color: #fff;
  background: var(--brown);
  border-bottom: 1px solid rgba(255, 255, 255, 0.08);
}
.header-inner {
  min-height: 96px;
  display: flex;
  align-items: center;
  gap: 38px;
}
.nav {
  display: flex;
  align-items: center;
  gap: 28px;
  margin-left: 10px;
  font-family: "Merriweather", Georgia, serif;
  font-size: 14px;
  font-weight: 400;
}
.nav a {
  transition: color 0.2s ease, opacity 0.2s ease;
}
.nav a:hover {
  color: #d8c3ae;
}
.search {
  height: 48px;
  margin-left: auto;
  display: flex;
  min-width: 390px;
  font-family: "Merriweather", Georgia, serif;
}
.search input {
  width: 294px;
  min-width: 0;
  color: var(--ink);
  background: #fff;
  border: 0;
  padding: 0 16px;
  border-radius: 0;
  appearance: none;
}
.search input::placeholder {
  color: #a39b95;
  font-weight: 400;
  opacity: 1;
}
.search input::-webkit-search-cancel-button {
  cursor: pointer;
}
.search button {
  width: 96px;
  color: #fff;
  background: #6b4b42;
  border: 1px solid #6b4b42;
  cursor: pointer;
  transition: background 0.2s ease;
}
.search button:hover {
  background: #7b594f;
}
.menu-button {
  display: none;
}
@media (max-width: 1080px) {
  .header-inner {
    gap: 22px;
  }
  .nav {
    gap: 18px;
    margin-left: 0;
  }
  .search {
    min-width: 310px;
  }
  .search input {
    width: 220px;
  }
}
@media (max-width: 780px) {
  .site-header,
  .header-inner {
    min-height: 76px;
  }
  .header-inner {
    flex-wrap: wrap;
    padding: 14px 0;
  }
  .menu-button {
    margin-left: auto;
    width: 42px;
    height: 42px;
    padding: 10px 8px;
    display: flex;
    flex-direction: column;
    justify-content: center;
    gap: 5px;
    color: #fff;
    background: transparent;
    border: 1px solid rgba(255, 255, 255, 0.35);
  }
  .menu-button span {
    display: block;
    height: 1px;
    background: currentColor;
  }
  .nav {
    position: absolute;
    z-index: 10;
    top: 76px;
    left: 0;
    right: 0;
    padding: 12px 18px 20px;
    display: none;
    flex-direction: column;
    align-items: flex-start;
    gap: 0;
    background: var(--brown);
    box-shadow: 0 10px 20px rgba(0, 0, 0, 0.15);
  }
  .nav--open {
    display: flex;
  }
  .nav a {
    width: 100%;
    padding: 12px 0;
    border-bottom: 1px solid rgba(255, 255, 255, 0.1);
  }
  .search {
    order: 3;
    flex: 1 0 100%;
    min-width: 0;
    height: 44px;
  }
  .search input {
    flex: 1;
    width: auto;
  }
  .search button {
    width: 82px;
  }
}
</style>
