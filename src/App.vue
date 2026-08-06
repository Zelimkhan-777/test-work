<template>
  <div class="app-shell">
    <site-header :query.sync="query" :menu-open.sync="menuOpen" />

    <main id="catalog" class="catalog container">
      <div class="catalog-heading">
        <div>
          <p class="eyebrow">Частная коллекция</p>
          <h1>Картины эпохи Возрождения</h1>
        </div>
        <p v-if="query" class="results-count">
          Найдено: {{ filteredProducts.length }}
        </p>
      </div>

      <transition-group
        v-if="filteredProducts.length"
        name="cards"
        tag="section"
        class="product-grid"
        aria-live="polite"
      >
        <product-card
          v-for="product in filteredProducts"
          :key="product.id"
          :product="product"
          :status="getStatus(product)"
          @open="openProduct"
          @buy="buy"
        />
      </transition-group>

      <div v-else class="empty-state" role="status">
        <svg viewBox="0 0 48 48" aria-hidden="true">
          <circle cx="21" cy="21" r="13" />
          <path d="m31 31 10 10" />
        </svg>
        <h2>Картины не найдены</h2>
        <p>Попробуйте изменить поисковый запрос.</p>
        <button type="button" @click="query = ''">Очистить поиск</button>
      </div>
    </main>

    <site-footer />
    <product-modal
      :selected="selected"
      :status="selected ? getStatus(selected) : 'idle'"
      @close="closeModal"
      @buy="buy"
    />
  </div>
</template>

<script>
import SiteHeader from "./components/SiteHeader.vue";
import ProductCard from "./components/ProductCard.vue";
import ProductModal from "./components/ProductModal.vue";
import SiteFooter from "./components/SiteFooter.vue";
import venus from "./assets/venus-main.jpg";
import venusDetailOne from "./assets/venus-detail-1.jpg";
import venusDetailTwo from "./assets/venus-detail-2.jpg";
import supper from "./assets/supper-main.jpg";
import supperDetailOne from "./assets/supper-detail-1.jpg";
import supperDetailTwo from "./assets/supper-detail-2.jpg";
import adam from "./assets/adam.png";
import adamDetailOne from "./assets/adam-detail-1.jpg";
import adamDetailTwo from "./assets/adam-detail-2.jpg";
import anatomy from "./assets/anatomy-main.jpg";
import anatomyDetailOne from "./assets/anatomy-detail-1.jpg";
import anatomyDetailTwo from "./assets/anatomy-detail-2.jpg";

const STORAGE_KEY = "the-art-cart";
const PRODUCTS = [
  {
    id: "venus",
    title: "Рождение Венеры",
    author: "Сандро Боттичелли",
    year: "ок. 1485",
    price: "1 000 000 $",
    oldPrice: "2 000 000 $",
    image: venus,
    position: "50% 48%",
    images: [
      { src: venus, label: "Общий вид" },
      { src: venusDetailOne, label: "Фрагмент с Венерой" },
      { src: venusDetailTwo, label: "Фрагмент композиции" },
    ],
    technique: "Темпера на холсте",
    size: "172,5 × 278,9 см",
    description:
      "Одна из главных работ флорентийского Возрождения. Богиня Венера прибывает к берегу на раковине, а лёгкий морской ветер наполняет сцену движением.",
  },
  {
    id: "supper",
    title: "Тайная вечеря",
    author: "Леонардо да Винчи",
    year: "1495–1498",
    price: "3 000 000 $",
    oldPrice: null,
    image: supper,
    position: "50% 50%",
    images: [
      { src: supper, label: "Общий вид" },
      { src: supperDetailOne, label: "Центр композиции" },
      { src: supperDetailTwo, label: "Фрагмент с апостолами" },
    ],
    technique: "Темпера по левкасу",
    size: "460 × 880 см",
    description:
      "Монументальная композиция изображает момент, когда Христос сообщает ученикам о предательстве. Перспектива и жесты героев делают сцену необыкновенно живой.",
  },
  {
    id: "adam",
    title: "Сотворение Адама",
    author: "Микеланджело",
    year: "ок. 1511",
    price: "5 000 000 $",
    oldPrice: "6 000 000 $",
    image: adam,
    position: "50% 50%",
    images: [
      { src: adam, label: "Общий вид" },
      { src: adamDetailOne, label: "Фигура Адама" },
      { src: adamDetailTwo, label: "Соприкосновение рук" },
    ],
    technique: "Фреска",
    size: "280 × 570 см",
    description:
      "Знаменитый фрагмент росписи Сикстинской капеллы. Почти соприкасающиеся руки Бога и Адама стали универсальным символом рождения жизни и творческого начала.",
  },
  {
    id: "anatomy",
    title: "Урок анатомии",
    author: "Рембрандт",
    year: "1632",
    price: "Продано на аукционе",
    oldPrice: null,
    image: anatomy,
    position: "50% 42%",
    sold: true,
    images: [
      { src: anatomy, label: "Общий вид" },
      { src: anatomyDetailOne, label: "Доктор Тульп" },
      { src: anatomyDetailTwo, label: "Группа хирургов" },
    ],
    technique: "Масло на холсте",
    size: "169,5 × 216,5 см",
    description:
      "Групповой портрет амстердамских хирургов построен вокруг публичной лекции доктора Тульпа. Свет объединяет лица наблюдателей и фигуру на анатомическом столе.",
  },
];

export default {
  name: "App",
  components: { SiteHeader, ProductCard, ProductModal, SiteFooter },
  data() {
    return {
      products: PRODUCTS,
      query: "",
      statuses: {},
      selected: null,
      menuOpen: false,
      timers: {},
      previousFocus: null,
    };
  },
  computed: {
    filteredProducts() {
      const needle = this.query.toLocaleLowerCase("ru-RU");
      if (!needle) return this.products;
      return this.products.filter((product) =>
        `${product.title} ${product.author}`
          .toLocaleLowerCase("ru-RU")
          .includes(needle),
      );
    },
  },
  created() {
    try {
      const saved = JSON.parse(localStorage.getItem(STORAGE_KEY) || "[]");
      const purchasableIds = new Set(
        this.products.filter((product) => !product.sold).map(({ id }) => id),
      );
      if (Array.isArray(saved))
        saved
          .filter((id) => purchasableIds.has(id))
          .forEach((id) => this.$set(this.statuses, id, "cart"));
    } catch (_) {
      // Storage may be unavailable in private browsing or restricted contexts.
    }
  },
  beforeDestroy() {
    Object.values(this.timers).forEach(clearTimeout);
    document.body.classList.remove("modal-open");
  },
  methods: {
    getStatus(product) {
      return this.statuses[product.id] || "idle";
    },
    buy(product) {
      if (product.sold || this.getStatus(product) !== "idle") return;
      this.$set(this.statuses, product.id, "processing");
      this.timers[product.id] = setTimeout(() => {
        this.$set(this.statuses, product.id, "cart");
        this.persistCart(
          Object.keys(this.statuses).filter(
            (id) => this.statuses[id] === "cart",
          ),
        );
        delete this.timers[product.id];
      }, 2000);
    },
    persistCart(cart) {
      try {
        localStorage.setItem(STORAGE_KEY, JSON.stringify(cart));
      } catch (_) {
        /* The UI remains usable when persistence is blocked. */
      }
    },
    openProduct(product) {
      this.previousFocus = document.activeElement;
      this.selected = product;
      document.body.classList.add("modal-open");
    },
    closeModal() {
      this.selected = null;
      document.body.classList.remove("modal-open");
      this.$nextTick(() => {
        if (this.previousFocus && document.contains(this.previousFocus))
          this.previousFocus.focus();
      });
    },
  },
};
</script>

<style scoped>
.catalog {
  min-height: calc(100vh - 192px);
  padding-top: 45px;
  padding-bottom: 88px;
}
.catalog-heading {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  margin-bottom: 36px;
}
h1 {
  margin: 0;
  font-size: clamp(29px, 3vw, 38px);
  font-weight: 700;
  line-height: 1.2;
}
.results-count {
  margin: 0 0 5px;
  color: #82766f;
  font-family: "Merriweather", Georgia, serif;
  font-size: 14px;
}
.product-grid {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 32px;
}
.cards-enter-active,
.cards-leave-active {
  transition: opacity 0.25s ease, transform 0.25s ease;
}
.cards-enter,
.cards-leave-to {
  opacity: 0;
  transform: scale(0.97);
}
.cards-leave-active {
  position: absolute;
}
.empty-state {
  min-height: 340px;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  text-align: center;
  border: 1px solid var(--line);
}
.empty-state svg {
  width: 52px;
  fill: none;
  stroke: #aa9d94;
  stroke-width: 1.5;
}
.empty-state h2 {
  margin: 18px 0 6px;
  font-size: 25px;
  font-weight: 700;
}
.empty-state p {
  margin: 0 0 20px;
  color: #837a74;
  font-family: "Merriweather", Georgia, serif;
  font-size: 14px;
}
.empty-state button {
  padding: 12px 20px;
  color: #fff;
  background: var(--brown);
  border: 0;
  cursor: pointer;
}
@media (max-width: 1080px) {
  .product-grid {
    grid-template-columns: repeat(2, 1fr);
    gap: 24px;
  }
}
@media (max-width: 780px) {
  .catalog {
    padding-top: 36px;
    padding-bottom: 56px;
  }
  .product-grid {
    grid-template-columns: 1fr 1fr;
  }
}
@media (max-width: 620px) {
  .catalog-heading {
    align-items: flex-start;
    flex-direction: column;
    gap: 12px;
    margin-bottom: 26px;
  }
  h1 {
    font-size: 28px;
  }
  .product-grid {
    grid-template-columns: 1fr;
    gap: 18px;
  }
}
</style>
