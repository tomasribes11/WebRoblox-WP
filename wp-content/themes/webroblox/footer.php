<footer class="py-4 mt-5 border-top">
    <div class="container text-center">
        <p class="text-body-secondary small mb-1">
            © <?php echo esc_html(date('Y')); ?> Mundo Roblox · Todos los derechos reservados
        </p>
        <p class="text-body-secondary small mb-0">
            <a href="<?php echo esc_url(webroblox_category_link('trucos')); ?>"
               class="text-body-secondary text-decoration-none me-3">Trucos</a>
            <a href="<?php echo esc_url(webroblox_category_link('guias')); ?>"
               class="text-body-secondary text-decoration-none me-3">Guías</a>
            <a href="<?php echo esc_url(webroblox_category_link('noticias')); ?>"
               class="text-body-secondary text-decoration-none">Noticias</a>
        </p>
    </div>
</footer>

<?php wp_footer(); ?>
</body>
</html>
