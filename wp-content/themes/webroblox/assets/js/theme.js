/**
 * theme.js — Dark/Light mode toggle
 *
 * La IIFE se ejecuta inmediatamente (antes del primer paint) para evitar
 * el flash de tema incorrecto al cargar la página.
 */
(function () {
    'use strict';

    // ─── Aplicar tema guardado en localStorage (antes del paint) ─────────────
    var saved = localStorage.getItem('wr_theme') || 'dark';
    document.documentElement.setAttribute('data-bs-theme', saved);

    // ─── Una vez el DOM está listo, inicializar el botón de toggle ───────────
    document.addEventListener('DOMContentLoaded', function () {
        var btn  = document.getElementById('theme-toggle');
        var icon = document.getElementById('theme-icon');

        if (!btn || !icon) return;

        function updateIcon(theme) {
            icon.textContent = theme === 'dark' ? '☀️' : '🌙';
            btn.setAttribute('title', theme === 'dark' ? 'Cambiar a modo claro' : 'Cambiar a modo oscuro');
        }

        updateIcon(saved);

        btn.addEventListener('click', function () {
            var current = document.documentElement.getAttribute('data-bs-theme');
            var next    = current === 'dark' ? 'light' : 'dark';
            document.documentElement.setAttribute('data-bs-theme', next);
            localStorage.setItem('wr_theme', next);
            updateIcon(next);
        });
    });
})();
