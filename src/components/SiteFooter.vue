<template>
  <footer id="contacts" class="site-footer">
    <div class="footer-inner container">
      <a id="about" class="brand brand--footer" href="#catalog"
        ><svg viewBox="0 0 44 44" aria-hidden="true">
          <path
            d="M22 2 42 22 22 42 2 22 22 2Zm0 7L9 22l13 13 13-13L22 9Zm0 5 8 8-8 8-8-8 8-8Z"
          /></svg
        ><span>THE ART</span></a
      >
      <nav class="footer-nav" aria-label="Навигация в подвале">
        <a href="#catalog">Каталог</a
        ><a id="delivery" href="#delivery">Доставка</a
        ><a id="payment" href="#payment">Оплата</a
        ><a href="#contacts">Контакты</a>
      </nav>
      <div class="footer-contact">
        <span>☎</span><a href="tel:+78125555555">+7 (812) 555-55-55</a>
      </div>
      <div class="footer-contact">
        <span>⌖</span>
        <address>г. Санкт-Петербург, ул. Ефимова, 3</address>
      </div>
    </div>
  </footer>
</template>

<script>
export default { name: "SiteFooter" };
</script>

<style scoped>
.site-footer {
  color: #f0ebe7;
  background: var(--brown);
}
.footer-inner {
  min-height: 96px;
  display: flex;
  align-items: center;
  gap: 36px;
}
.brand--footer {
  margin-right: 12px;
  opacity: 0.78;
}
.footer-nav {
  display: flex;
  gap: 28px;
  font: 400 14px "Merriweather", Georgia, serif;
}
.footer-nav a {
  transition: color 0.2s ease, opacity 0.2s ease;
}
.footer-nav a:hover {
  color: #d8c3ae;
}
.footer-contact {
  margin-left: auto;
  display: flex;
  align-items: center;
  gap: 9px;
  color: #ded5ce;
  font: 700 14px "Merriweather", Georgia, serif;
  white-space: nowrap;
}
.footer-contact + .footer-contact {
  margin-left: 10px;
}
.footer-contact span {
  color: #ab9b90;
}
.footer-contact address {
  font-style: normal;
}
@media (max-width: 1080px) {
  .footer-nav {
    display: none;
  }
  .footer-contact {
    margin-left: auto;
  }
}
@media (max-width: 780px) {
  .footer-inner {
    min-height: 140px;
    flex-wrap: wrap;
    padding: 24px 0;
  }
  .footer-contact {
    flex: 1 0 calc(50% - 18px);
    margin: 0;
    white-space: normal;
  }
  .footer-contact + .footer-contact {
    margin-left: 0;
  }
}
@media (max-width: 620px) {
  .footer-inner {
    display: grid;
    grid-template-columns: 1fr;
    gap: 18px;
  }
  .footer-contact {
    margin: 0;
  }
}
</style>
