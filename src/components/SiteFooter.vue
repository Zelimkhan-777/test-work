<template>
  <footer id="contacts" class="site-footer">
    <div class="footer-inner container">
      <a class="brand brand--footer" href="#catalog"><svg viewBox="0 0 44 44" aria-hidden="true"><path d="M22 2 42 22 22 42 2 22 22 2Zm0 7L9 22l13 13 13-13L22 9Zm0 5 8 8-8 8-8-8 8-8Z" /></svg><span>THE ART</span></a>
      <nav class="footer-nav" aria-label="Навигация в подвале">
        <a href="#catalog">Каталог</a><a id="delivery" href="#delivery">Доставка</a><a id="payment" href="#payment">Оплата</a><a href="#contacts">Контакты</a>
      </nav>
      <div class="footer-contact"><span>☎</span><a href="tel:+78125555555">+7 (812) 555-55-55</a></div>
      <div class="footer-contact"><span>⌖</span><address>г. Санкт-Петербург, ул. Ефимова, 3</address></div>
    </div>
  </footer>
</template>

<script>
export default { name: "SiteFooter" };
</script>
