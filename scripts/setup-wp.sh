#!/bin/sh
# setup-wp.sh — Setup automatizado de WordPress con wp-cli
# Idempotente: seguro ejecutar varias veces.
set -e

WP="wp --allow-root --path=/var/www/html"

# ─── 1. Esperar MySQL ────────────────────────────────────────────────────────
sh /scripts/wait-for-mysql.sh

# ─── 2. Instalar WordPress core (si no está instalado) ───────────────────────
if $WP core is-installed 2>/dev/null; then
    echo "WordPress ya instalado. Saltando instalación de core."
else
    echo "Instalando WordPress core..."
    $WP core install \
        --url="${WP_HOME}" \
        --title="${WP_SITE_TITLE}" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --skip-email
fi

# ─── 3. Configurar permalinks ────────────────────────────────────────────────
echo "Configurando permalinks..."
$WP rewrite structure '/%category%/%postname%/'
$WP rewrite flush

# ─── 4. Habilitar registro de usuarios ───────────────────────────────────────
$WP option update users_can_register 1

# ─── 5. Instalar y activar Polylang ─────────────────────────────────────────
echo "Instalando Polylang..."
if ! $WP plugin is-active polylang 2>/dev/null; then
    $WP plugin install polylang --activate
else
    echo "Polylang ya activo."
fi

# ─── 6. Activar tema webroblox ───────────────────────────────────────────────
echo "Activando tema webroblox..."
$WP theme activate webroblox

# ─── 7. Crear idiomas en Polylang ────────────────────────────────────────────
echo "Configurando idiomas (ES/EN/FR)..."
$WP pll lang create "Español"  es es_ES 0 ltr 2>/dev/null || true
$WP pll lang create "English"  en en_US 0 ltr 2>/dev/null || true
$WP pll lang create "Français" fr fr_FR 0 ltr 2>/dev/null || true

# ─── 8. Eliminar categoría por defecto "Uncategorized" ───────────────────────
$WP term delete category 1 2>/dev/null || true

# ─── 9. Crear categorías y sus traducciones ───────────────────────────────────
echo "Creando categorías..."

create_or_get_term() {
    # Uso: create_or_get_term <nombre> <slug>
    local NAME="$1"
    local SLUG="$2"
    EXISTING=$($WP term list category --field=term_id --name="${NAME}" 2>/dev/null || true)
    if [ -n "$EXISTING" ]; then
        echo "$EXISTING"
    else
        $WP term create category "${NAME}" --slug="${SLUG}" --porcelain
    fi
}

# Trucos
TRUCOS_ES=$(create_or_get_term "Trucos"   "trucos")
TRUCOS_EN=$(create_or_get_term "Tricks"   "tricks")
TRUCOS_FR=$(create_or_get_term "Astuces"  "astuces")

# Guías
GUIAS_ES=$(create_or_get_term "Guías"    "guias")
GUIAS_EN=$(create_or_get_term "Guides"   "guides")
GUIAS_FR=$(create_or_get_term "Guides FR" "guides-fr")

# Noticias
NOTICIAS_ES=$(create_or_get_term "Noticias"   "noticias")
NOTICIAS_EN=$(create_or_get_term "News"       "news")
NOTICIAS_FR=$(create_or_get_term "Actualités" "actualites")

# Asignar idiomas a categorías
$WP pll term set_language "$TRUCOS_ES"   es 2>/dev/null || true
$WP pll term set_language "$TRUCOS_EN"   en 2>/dev/null || true
$WP pll term set_language "$TRUCOS_FR"   fr 2>/dev/null || true

$WP pll term set_language "$GUIAS_ES"    es 2>/dev/null || true
$WP pll term set_language "$GUIAS_EN"    en 2>/dev/null || true
$WP pll term set_language "$GUIAS_FR"    fr 2>/dev/null || true

$WP pll term set_language "$NOTICIAS_ES" es 2>/dev/null || true
$WP pll term set_language "$NOTICIAS_EN" en 2>/dev/null || true
$WP pll term set_language "$NOTICIAS_FR" fr 2>/dev/null || true

# Enlazar traducciones de categorías
$WP pll term save_translations "$TRUCOS_ES"   "$TRUCOS_EN"   "$TRUCOS_FR"   2>/dev/null || true
$WP pll term save_translations "$GUIAS_ES"    "$GUIAS_EN"    "$GUIAS_FR"    2>/dev/null || true
$WP pll term save_translations "$NOTICIAS_ES" "$NOTICIAS_EN" "$NOTICIAS_FR" 2>/dev/null || true

echo "Categorías creadas: Trucos($TRUCOS_ES), Guías($GUIAS_ES), Noticias($NOTICIAS_ES)"

# ─── 10. Función helper: crear artículo con 3 traducciones ───────────────────
create_article() {
    # Argumentos: titulo_es contenido_es extracto_es slug_es cat_es
    #             titulo_en contenido_en extracto_en slug_en cat_en
    #             titulo_fr contenido_fr extracto_fr slug_fr cat_fr
    local T_ES="$1" C_ES="$2" X_ES="$3" S_ES="$4" CAT_ES="$5"
    local T_EN="$6" C_EN="$7" X_EN="$8" S_EN="$9" CAT_EN="${10}"
    local T_FR="${11}" C_FR="${12}" X_FR="${13}" S_FR="${14}" CAT_FR="${15}"

    ID_ES=$($WP post create \
        --post_title="${T_ES}" --post_content="${C_ES}" --post_excerpt="${X_ES}" \
        --post_status=publish --post_name="${S_ES}" \
        --post_category="${CAT_ES}" --porcelain 2>/dev/null || echo "")

    ID_EN=$($WP post create \
        --post_title="${T_EN}" --post_content="${C_EN}" --post_excerpt="${X_EN}" \
        --post_status=publish --post_name="${S_EN}" \
        --post_category="${CAT_EN}" --porcelain 2>/dev/null || echo "")

    ID_FR=$($WP post create \
        --post_title="${T_FR}" --post_content="${C_FR}" --post_excerpt="${X_FR}" \
        --post_status=publish --post_name="${S_FR}" \
        --post_category="${CAT_FR}" --porcelain 2>/dev/null || echo "")

    if [ -n "$ID_ES" ] && [ -n "$ID_EN" ] && [ -n "$ID_FR" ]; then
        $WP pll post set_language "$ID_ES" es 2>/dev/null || true
        $WP pll post set_language "$ID_EN" en 2>/dev/null || true
        $WP pll post set_language "$ID_FR" fr 2>/dev/null || true
        $WP pll post save_translations "$ID_ES" "$ID_EN" "$ID_FR" 2>/dev/null || true
        $WP post meta set "$ID_ES" _view_count 0 2>/dev/null || true
        $WP post meta set "$ID_EN" _view_count 0 2>/dev/null || true
        $WP post meta set "$ID_FR" _view_count 0 2>/dev/null || true
    fi
}

# ─── 11. Crear artículos de muestra ──────────────────────────────────────────
echo "Creando artículos de muestra..."

# ── TRUCOS ──────────────────────────────────────────────────────────────────

# Artículo 1 — Robux
create_article \
    "5 trucos secretos para conseguir Robux rápido" \
    "<p>Aprende cómo obtener Robux de forma legal y eficiente. Desde participar en el programa Roblox Premium hasta crear y vender tus propios objetos virtuales, existen múltiples formas de aumentar tu saldo.</p><h2>1. Programa Premium</h2><p>Suscribiéndote a Roblox Premium recibes una cantidad mensual de Robux según el nivel elegido.</p><h2>2. Vende accesorios</h2><p>Si tienes habilidades de diseño, crea accesorios y véndelos en el Marketplace.</p><h2>3. Crea un juego</h2><p>Los juegos populares generan Robux a través del GamePass y las compras dentro del juego.</p>" \
    "Aprende a obtener Robux legalmente con estos métodos probados." \
    "trucos-robux" "$TRUCOS_ES" \
    "5 secret tricks to get Robux fast" \
    "<p>Learn how to get Robux legally and efficiently. From joining Roblox Premium to creating and selling virtual items, there are many ways to grow your balance.</p><h2>1. Premium Program</h2><p>Subscribing to Roblox Premium gives you a monthly Robux allowance.</p><h2>2. Sell accessories</h2><p>If you have design skills, create accessories and sell them on the Marketplace.</p><h2>3. Create a game</h2><p>Popular games earn Robux through GamePasses and in-game purchases.</p>" \
    "Learn to earn Robux legally with these proven methods." \
    "tricks-robux" "$TRUCOS_EN" \
    "5 astuces secrètes pour obtenir des Robux rapidement" \
    "<p>Apprenez à obtenir des Robux légalement et efficacement. De l'adhésion à Roblox Premium à la création et la vente d'objets virtuels, il existe de nombreuses façons d'augmenter votre solde.</p><h2>1. Programme Premium</h2><p>L'abonnement à Roblox Premium vous donne une allocation mensuelle de Robux.</p><h2>2. Vendez des accessoires</h2><p>Si vous avez des compétences en design, créez des accessoires et vendez-les sur le Marketplace.</p>" \
    "Apprenez à gagner des Robux légalement avec ces méthodes éprouvées." \
    "astuces-robux" "$TRUCOS_FR"

# Artículo 2 — Personalización de avatar
create_article \
    "Cómo personalizar tu avatar al máximo en Roblox" \
    "<p>Tu avatar es tu identidad en Roblox. Aprende a sacarle el máximo partido con combinaciones creativas y accesorios únicos.</p><h2>Editor de avatar</h2><p>Accede al editor desde la web o la app y experimenta con cuerpos, colores y ropa.</p><h2>Ropa gratuita</h2><p>Hay miles de prendas gratuitas en el catálogo. Busca por precio '0 Robux'.</p>" \
    "Domina el editor de avatar y crea un personaje único sin gastar nada." \
    "personalizar-avatar" "$TRUCOS_ES" \
    "How to fully customize your avatar in Roblox" \
    "<p>Your avatar is your identity in Roblox. Learn how to make the most of it with creative combinations and unique accessories.</p><h2>Avatar Editor</h2><p>Access the editor from the web or app and experiment with bodies, colors, and clothes.</p><h2>Free clothing</h2><p>There are thousands of free items in the catalog. Search by price '0 Robux'.</p>" \
    "Master the avatar editor and create a unique character without spending anything." \
    "customize-avatar" "$TRUCOS_EN" \
    "Comment personnaliser votre avatar au maximum sur Roblox" \
    "<p>Votre avatar est votre identité sur Roblox. Apprenez à en tirer le meilleur parti avec des combinaisons créatives et des accessoires uniques.</p><h2>Éditeur d'avatar</h2><p>Accédez à l'éditeur depuis le web ou l'application et expérimentez avec les corps, couleurs et vêtements.</p>" \
    "Maîtrisez l'éditeur d'avatar et créez un personnage unique sans rien dépenser." \
    "personnaliser-avatar" "$TRUCOS_FR"

# Artículo 3 — Controles y atajos
create_article \
    "Todos los controles y atajos de teclado que debes conocer" \
    "<p>Conocer los controles avanzados de Roblox te dará ventaja en cualquier juego. Estos son los atajos más útiles.</p><h2>Movimiento</h2><p>WASD para mover, Espacio para saltar, Shift para correr.</p><h2>Cámara</h2><p>Rueda del ratón para zoom, clic derecho para rotar la vista.</p><h2>Chat</h2><p>/ para abrir el chat, Esc para cerrar sin enviar.</p>" \
    "Aprende todos los atajos de teclado para jugar como un profesional." \
    "controles-atajos" "$TRUCOS_ES" \
    "All keyboard controls and shortcuts you need to know" \
    "<p>Knowing Roblox's advanced controls will give you an advantage in any game. These are the most useful shortcuts.</p><h2>Movement</h2><p>WASD to move, Space to jump, Shift to run.</p><h2>Camera</h2><p>Mouse wheel to zoom, right-click to rotate the view.</p><h2>Chat</h2><p>/ to open chat, Esc to close without sending.</p>" \
    "Learn all keyboard shortcuts to play like a professional." \
    "controls-shortcuts" "$TRUCOS_EN" \
    "Tous les contrôles clavier et raccourcis que vous devez connaître" \
    "<p>Connaître les contrôles avancés de Roblox vous donnera un avantage dans n'importe quel jeu. Voici les raccourcis les plus utiles.</p><h2>Mouvement</h2><p>WASD pour se déplacer, Espace pour sauter, Shift pour courir.</p><h2>Caméra</h2><p>Molette pour zoomer, clic droit pour faire pivoter la vue.</p>" \
    "Apprenez tous les raccourcis clavier pour jouer comme un professionnel." \
    "controles-raccourcis" "$TRUCOS_FR"

# Artículo 4 — Grupos y comunidades
create_article \
    "Cómo unirte a grupos y sacarles el máximo partido" \
    "<p>Los grupos de Roblox son comunidades que ofrecen ventajas exclusivas, rangos y hasta Robux gratis para sus miembros activos.</p><h2>Buscar grupos</h2><p>En la sección Groups de tu perfil puedes buscar por nombre o categoría.</p><h2>Beneficios</h2><p>Muchos grupos ofrecen uniformes gratuitos y sorteos de Robux.</p>" \
    "Descubre cómo los grupos pueden darte ventajas y recompensas en Roblox." \
    "grupos-comunidades" "$TRUCOS_ES" \
    "How to join groups and get the most out of them" \
    "<p>Roblox groups are communities that offer exclusive benefits, ranks, and even free Robux for active members.</p><h2>Find groups</h2><p>In the Groups section of your profile you can search by name or category.</p><h2>Benefits</h2><p>Many groups offer free uniforms and Robux giveaways.</p>" \
    "Discover how groups can give you advantages and rewards in Roblox." \
    "groups-communities" "$TRUCOS_EN" \
    "Comment rejoindre des groupes et en tirer le maximum" \
    "<p>Les groupes Roblox sont des communautés qui offrent des avantages exclusifs, des rangs et même des Robux gratuits pour les membres actifs.</p><h2>Trouver des groupes</h2><p>Dans la section Groupes de votre profil, vous pouvez chercher par nom ou catégorie.</p>" \
    "Découvrez comment les groupes peuvent vous donner des avantages et des récompenses sur Roblox." \
    "groupes-communautes" "$TRUCOS_FR"

# Artículo 5 — Seguridad de cuenta
create_article \
    "5 formas de proteger tu cuenta de Roblox de los hackers" \
    "<p>La seguridad de tu cuenta es fundamental. Sigue estos consejos para mantener tu cuenta y tus Robux seguros.</p><h2>Autenticación en dos pasos</h2><p>Actívala en la configuración de seguridad de tu cuenta.</p><h2>Contraseña fuerte</h2><p>Usa al menos 12 caracteres con mayúsculas, números y símbolos.</p><h2>No compartas credenciales</h2><p>Roblox nunca te pedirá tu contraseña en el chat.</p>" \
    "Protege tu cuenta y tus Robux con estos consejos de seguridad esenciales." \
    "seguridad-cuenta" "$TRUCOS_ES" \
    "5 ways to protect your Roblox account from hackers" \
    "<p>Account security is essential. Follow these tips to keep your account and Robux safe.</p><h2>Two-factor authentication</h2><p>Enable it in your account security settings.</p><h2>Strong password</h2><p>Use at least 12 characters with uppercase letters, numbers, and symbols.</p><h2>Don't share credentials</h2><p>Roblox will never ask for your password in chat.</p>" \
    "Protect your account and Robux with these essential security tips." \
    "account-security" "$TRUCOS_EN" \
    "5 façons de protéger votre compte Roblox des pirates" \
    "<p>La sécurité de votre compte est essentielle. Suivez ces conseils pour garder votre compte et vos Robux en sécurité.</p><h2>Authentification à deux facteurs</h2><p>Activez-la dans les paramètres de sécurité de votre compte.</p><h2>Mot de passe fort</h2><p>Utilisez au moins 12 caractères avec des majuscules, des chiffres et des symboles.</p>" \
    "Protégez votre compte et vos Robux avec ces conseils de sécurité essentiels." \
    "securite-compte" "$TRUCOS_FR"

# ── GUÍAS ───────────────────────────────────────────────────────────────────

# Artículo 6 — Crear un juego
create_article \
    "Guía completa para crear tu primer juego en Roblox Studio" \
    "<p>Roblox Studio es la herramienta gratuita de Roblox para crear juegos. Esta guía te lleva paso a paso desde cero hasta publicar tu primer juego.</p><h2>Instalación</h2><p>Descarga Roblox Studio desde roblox.com/create. Es gratuito.</p><h2>Interfaz básica</h2><p>El Explorer muestra todos los objetos de tu escena. El Toolbox tiene assets gratuitos.</p><h2>Publicar</h2><p>File → Publish to Roblox para subir tu juego.</p>" \
    "Aprende a crear y publicar tu primer juego en Roblox Studio paso a paso." \
    "crear-primer-juego" "$GUIAS_ES" \
    "Complete guide to creating your first game in Roblox Studio" \
    "<p>Roblox Studio is Roblox's free game creation tool. This guide takes you step by step from scratch to publishing your first game.</p><h2>Installation</h2><p>Download Roblox Studio from roblox.com/create. It's free.</p><h2>Basic interface</h2><p>The Explorer shows all objects in your scene. The Toolbox has free assets.</p><h2>Publish</h2><p>File → Publish to Roblox to upload your game.</p>" \
    "Learn to create and publish your first game in Roblox Studio step by step." \
    "create-first-game" "$GUIAS_EN" \
    "Guide complète pour créer votre premier jeu dans Roblox Studio" \
    "<p>Roblox Studio est l'outil gratuit de création de jeux de Roblox. Ce guide vous accompagne étape par étape de zéro jusqu'à la publication de votre premier jeu.</p><h2>Installation</h2><p>Téléchargez Roblox Studio sur roblox.com/create. C'est gratuit.</p><h2>Interface de base</h2><p>L'Explorer affiche tous les objets de votre scène. La Toolbox contient des assets gratuits.</p>" \
    "Apprenez à créer et publier votre premier jeu dans Roblox Studio étape par étape." \
    "creer-premier-jeu" "$GUIAS_FR"

# Artículo 7 — Lua básico
create_article \
    "Introducción a Lua: programa tu primer script en Roblox" \
    "<p>Lua es el lenguaje de programación de Roblox. Con unos conceptos básicos podrás crear comportamientos interactivos en tus juegos.</p><h2>Variables</h2><p>local nombre = 'Roblox' — las variables locales son más eficientes.</p><h2>Funciones</h2><p>local function saludar() print('Hola Roblox') end</p><h2>Eventos</h2><p>game.Players.PlayerAdded:Connect(function(player) print(player.Name) end)</p>" \
    "Aprende los fundamentos de Lua y empieza a programar tus propios juegos." \
    "introduccion-lua" "$GUIAS_ES" \
    "Introduction to Lua: program your first script in Roblox" \
    "<p>Lua is Roblox's programming language. With a few basic concepts you can create interactive behaviors in your games.</p><h2>Variables</h2><p>local name = 'Roblox' — local variables are more efficient.</p><h2>Functions</h2><p>local function greet() print('Hello Roblox') end</p><h2>Events</h2><p>game.Players.PlayerAdded:Connect(function(player) print(player.Name) end)</p>" \
    "Learn Lua fundamentals and start programming your own games." \
    "intro-lua" "$GUIAS_EN" \
    "Introduction à Lua : programmez votre premier script sur Roblox" \
    "<p>Lua est le langage de programmation de Roblox. Avec quelques concepts de base, vous pourrez créer des comportements interactifs dans vos jeux.</p><h2>Variables</h2><p>local nom = 'Roblox' — les variables locales sont plus efficaces.</p><h2>Fonctions</h2><p>local function saluer() print('Bonjour Roblox') end</p>" \
    "Apprenez les fondamentaux de Lua et commencez à programmer vos propres jeux." \
    "intro-lua-fr" "$GUIAS_FR"

# Artículo 8 — Monetización
create_article \
    "Guía de monetización: cómo ganar dinero real con tus juegos" \
    "<p>Los creadores de Roblox pueden convertir sus Robux en dinero real a través del programa DevEx. Descubre cómo maximizar tus ingresos.</p><h2>GamePasses</h2><p>Vende ventajas únicas dentro de tu juego a cambio de Robux.</p><h2>Developer Products</h2><p>Ítems consumibles que los jugadores pueden comprar repetidamente.</p><h2>DevEx</h2><p>Necesitas al menos 100.000 Robux y una cuenta Premium para canjear.</p>" \
    "Descubre cómo convertir tu creatividad en ingresos reales con Roblox DevEx." \
    "monetizacion-juegos" "$GUIAS_ES" \
    "Monetization guide: how to earn real money with your games" \
    "<p>Roblox creators can convert their Robux into real money through the DevEx program. Discover how to maximize your earnings.</p><h2>GamePasses</h2><p>Sell unique advantages within your game in exchange for Robux.</p><h2>Developer Products</h2><p>Consumable items that players can buy repeatedly.</p><h2>DevEx</h2><p>You need at least 100,000 Robux and a Premium account to cash out.</p>" \
    "Discover how to turn your creativity into real income with Roblox DevEx." \
    "game-monetization" "$GUIAS_EN" \
    "Guide de monétisation : comment gagner de l'argent réel avec vos jeux" \
    "<p>Les créateurs Roblox peuvent convertir leurs Robux en argent réel via le programme DevEx. Découvrez comment maximiser vos revenus.</p><h2>GamePasses</h2><p>Vendez des avantages uniques dans votre jeu en échange de Robux.</p><h2>Produits développeur</h2><p>Articles consommables que les joueurs peuvent acheter à plusieurs reprises.</p>" \
    "Découvrez comment transformer votre créativité en revenus réels avec Roblox DevEx." \
    "monetisation-jeux" "$GUIAS_FR"

# Artículo 9 — Diseño de mapas
create_article \
    "Cómo diseñar mapas atractivos que enganchen a los jugadores" \
    "<p>Un buen diseño de mapa es la diferencia entre un juego olvidable y uno que los jugadores vuelven a jugar. Estos principios te ayudarán.</p><h2>Guía visual</h2><p>Usa colores y luces para dirigir al jugador hacia los objetivos principales.</p><h2>Flujo de jugabilidad</h2><p>El mapa debe tener una progresión natural sin callejones sin salida.</p><h2>Optimización</h2><p>Usa LOD (Level of Detail) y agrupa las partes para mejorar el rendimiento.</p>" \
    "Aprende los principios de diseño de niveles para crear mapas que los jugadores adoren." \
    "diseno-mapas" "$GUIAS_ES" \
    "How to design attractive maps that keep players hooked" \
    "<p>Good map design is the difference between a forgettable game and one players keep coming back to. These principles will help you.</p><h2>Visual guidance</h2><p>Use colors and lights to direct players toward main objectives.</p><h2>Gameplay flow</h2><p>The map should have a natural progression without dead ends.</p><h2>Optimization</h2><p>Use LOD (Level of Detail) and group parts to improve performance.</p>" \
    "Learn level design principles to create maps that players love." \
    "map-design" "$GUIAS_EN" \
    "Comment concevoir des cartes attrayantes qui accrochent les joueurs" \
    "<p>Un bon design de carte fait la différence entre un jeu oubliable et un jeu auquel les joueurs reviennent. Ces principes vous aideront.</p><h2>Guidage visuel</h2><p>Utilisez les couleurs et les lumières pour diriger les joueurs vers les objectifs principaux.</p><h2>Flux de gameplay</h2><p>La carte doit avoir une progression naturelle sans impasses.</p>" \
    "Apprenez les principes de level design pour créer des cartes que les joueurs adorent." \
    "conception-cartes" "$GUIAS_FR"

# Artículo 10 — Colaboración
create_article \
    "Trabaja en equipo: colaboración efectiva en proyectos de Roblox" \
    "<p>Los mejores juegos de Roblox son creados por equipos. Aprende a organizar tu equipo y usar las herramientas de colaboración disponibles.</p><h2>Team Create</h2><p>Activa Team Create en Studio para que varios desarrolladores trabajen simultáneamente.</p><h2>Control de versiones</h2><p>Roblox guarda el historial de versiones automáticamente. Puedes revertir cambios.</p><h2>Roles</h2><p>Define claramente quién hace qué: scripter, builder, designer.</p>" \
    "Descubre cómo organizar un equipo de desarrollo eficiente en Roblox Studio." \
    "colaboracion-equipos" "$GUIAS_ES" \
    "Teamwork: effective collaboration on Roblox projects" \
    "<p>The best Roblox games are made by teams. Learn how to organize your team and use the collaboration tools available.</p><h2>Team Create</h2><p>Enable Team Create in Studio to let multiple developers work simultaneously.</p><h2>Version control</h2><p>Roblox saves version history automatically. You can revert changes.</p><h2>Roles</h2><p>Clearly define who does what: scripter, builder, designer.</p>" \
    "Discover how to organize an efficient development team in Roblox Studio." \
    "team-collaboration" "$GUIAS_EN" \
    "Travail d'équipe : collaboration efficace sur les projets Roblox" \
    "<p>Les meilleurs jeux Roblox sont créés par des équipes. Apprenez à organiser votre équipe et à utiliser les outils de collaboration disponibles.</p><h2>Team Create</h2><p>Activez Team Create dans Studio pour permettre à plusieurs développeurs de travailler simultanément.</p><h2>Contrôle de version</h2><p>Roblox enregistre l'historique des versions automatiquement. Vous pouvez annuler les modifications.</p>" \
    "Découvrez comment organiser une équipe de développement efficace dans Roblox Studio." \
    "collaboration-equipe" "$GUIAS_FR"

# ── NOTICIAS ─────────────────────────────────────────────────────────────────

# Artículo 11 — Nueva temporada
create_article \
    "Nueva temporada 2025: todo lo que llega a Roblox este mes" \
    "<p>Roblox arranca la temporada 2025 con una oleada de novedades: nuevos eventos, colaboraciones con marcas globales y actualizaciones del motor gráfico.</p><h2>Eventos de temporada</h2><p>El Egg Hunt anual vuelve con más de 50 huevos coleccionables repartidos en juegos de toda la plataforma.</p><h2>Colaboraciones</h2><p>Marcas de moda y entretenimiento traen accesorios exclusivos por tiempo limitado.</p>" \
    "Descubre todas las novedades que trae Roblox en la temporada 2025." \
    "nueva-temporada-2025" "$NOTICIAS_ES" \
    "New 2025 season: everything coming to Roblox this month" \
    "<p>Roblox kicks off the 2025 season with a wave of news: new events, collaborations with global brands, and graphics engine updates.</p><h2>Seasonal events</h2><p>The annual Egg Hunt returns with more than 50 collectible eggs spread across games throughout the platform.</p><h2>Collaborations</h2><p>Fashion and entertainment brands bring exclusive limited-time accessories.</p>" \
    "Discover all the new features Roblox brings in the 2025 season." \
    "new-season-2025" "$NOTICIAS_EN" \
    "Nouvelle saison 2025 : tout ce qui arrive sur Roblox ce mois-ci" \
    "<p>Roblox lance la saison 2025 avec une vague de nouveautés : de nouveaux événements, des collaborations avec des marques mondiales et des mises à jour du moteur graphique.</p><h2>Événements saisonniers</h2><p>La chasse aux œufs annuelle revient avec plus de 50 œufs à collectionner répartis dans les jeux de toute la plateforme.</p>" \
    "Découvrez toutes les nouveautés que Roblox apporte lors de la saison 2025." \
    "nouvelle-saison-2025" "$NOTICIAS_FR"

# Artículo 12 — Actualización del motor
create_article \
    "Roblox actualiza su motor gráfico: así lucirán los juegos en 2025" \
    "<p>La nueva actualización del motor gráfico de Roblox trae iluminación dinámica, sombras mejoradas y soporte para materiales PBR de alta calidad.</p><h2>Iluminación dinámica</h2><p>Los juegos podrán usar luz volumétrica y sombras suaves que antes solo se veían en motores comerciales.</p><h2>PBR Materials</h2><p>Los materiales con Physically Based Rendering hacen que los objetos se vean más realistas.</p>" \
    "El motor gráfico de Roblox da un salto cualitativo con estas mejoras visuales." \
    "actualizacion-motor-grafico" "$NOTICIAS_ES" \
    "Roblox updates its graphics engine: here's how games will look in 2025" \
    "<p>The new Roblox graphics engine update brings dynamic lighting, improved shadows, and support for high-quality PBR materials.</p><h2>Dynamic lighting</h2><p>Games can now use volumetric light and soft shadows previously only seen in commercial engines.</p><h2>PBR Materials</h2><p>Physically Based Rendering materials make objects look more realistic.</p>" \
    "Roblox's graphics engine takes a qualitative leap with these visual improvements." \
    "graphics-engine-update" "$NOTICIAS_EN" \
    "Roblox met à jour son moteur graphique : voici à quoi ressembleront les jeux en 2025" \
    "<p>La nouvelle mise à jour du moteur graphique de Roblox apporte un éclairage dynamique, des ombres améliorées et la prise en charge des matériaux PBR de haute qualité.</p><h2>Éclairage dynamique</h2><p>Les jeux pourront utiliser la lumière volumétrique et les ombres douces auparavant réservées aux moteurs commerciaux.</p>" \
    "Le moteur graphique de Roblox fait un bond qualitatif avec ces améliorations visuelles." \
    "mise-a-jour-moteur" "$NOTICIAS_FR"

# Artículo 13 — Evento especial
create_article \
    "Evento especial: Roblox celebra el Día de la Tierra con juegos ecológicos" \
    "<p>Roblox se une a la celebración del Día de la Tierra con una serie de juegos y experiencias educativas sobre medioambiente y sostenibilidad.</p><h2>Juegos destacados</h2><p>Más de 20 experiencias participan en el evento con misiones ecológicas y recompensas exclusivas.</p><h2>Recompensas</h2><p>Consigue artículos de avatar con temática ecológica completando las misiones del evento.</p>" \
    "Roblox se suma al Día de la Tierra con eventos y recompensas especiales." \
    "evento-dia-tierra" "$NOTICIAS_ES" \
    "Special event: Roblox celebrates Earth Day with eco-friendly games" \
    "<p>Roblox joins the Earth Day celebration with a series of games and educational experiences about the environment and sustainability.</p><h2>Featured games</h2><p>More than 20 experiences participate in the event with ecological missions and exclusive rewards.</p><h2>Rewards</h2><p>Get eco-themed avatar items by completing the event missions.</p>" \
    "Roblox joins Earth Day with special events and rewards." \
    "earth-day-event" "$NOTICIAS_EN" \
    "Événement spécial : Roblox célèbre le Jour de la Terre avec des jeux écologiques" \
    "<p>Roblox se joint à la célébration du Jour de la Terre avec une série de jeux et d'expériences éducatives sur l'environnement et la durabilité.</p><h2>Jeux en vedette</h2><p>Plus de 20 expériences participent à l'événement avec des missions écologiques et des récompenses exclusives.</p>" \
    "Roblox rejoint le Jour de la Terre avec des événements et des récompenses spéciaux." \
    "evenement-jour-terre" "$NOTICIAS_FR"

# Artículo 14 — Nuevas funciones de chat
create_article \
    "Roblox mejora el sistema de chat con traducción automática en tiempo real" \
    "<p>La plataforma lanza una función de traducción automática en el chat que permite a jugadores de diferentes países comunicarse sin barreras de idioma.</p><h2>Cómo funciona</h2><p>El sistema detecta el idioma del mensaje y lo traduce automáticamente al idioma preferido del receptor.</p><h2>Idiomas soportados</h2><p>Actualmente disponible en más de 15 idiomas incluyendo español, inglés, francés, portugués y japonés.</p>" \
    "La nueva función de traducción automática elimina las barreras de idioma en Roblox." \
    "chat-traduccion-automatica" "$NOTICIAS_ES" \
    "Roblox improves the chat system with real-time automatic translation" \
    "<p>The platform launches an automatic translation feature in chat that allows players from different countries to communicate without language barriers.</p><h2>How it works</h2><p>The system detects the language of the message and automatically translates it to the receiver's preferred language.</p><h2>Supported languages</h2><p>Currently available in more than 15 languages including Spanish, English, French, Portuguese and Japanese.</p>" \
    "The new automatic translation feature eliminates language barriers in Roblox." \
    "chat-auto-translation" "$NOTICIAS_EN" \
    "Roblox améliore le système de chat avec la traduction automatique en temps réel" \
    "<p>La plateforme lance une fonctionnalité de traduction automatique dans le chat qui permet aux joueurs de différents pays de communiquer sans barrières linguistiques.</p><h2>Comment ça fonctionne</h2><p>Le système détecte la langue du message et le traduit automatiquement dans la langue préférée du destinataire.</p>" \
    "La nouvelle fonctionnalité de traduction automatique élimine les barrières linguistiques sur Roblox." \
    "chat-traduction-automatique" "$NOTICIAS_FR"

# Artículo 15 — Estadísticas del año
create_article \
    "Roblox en números: las estadísticas más impresionantes de 2024" \
    "<p>2024 ha sido un año récord para Roblox. Repasamos las estadísticas más llamativas que demuestran el crecimiento exponencial de la plataforma.</p><h2>Usuarios activos</h2><p>Roblox superó los 88 millones de usuarios activos diarios, un incremento del 22% respecto a 2023.</p><h2>Juegos publicados</h2><p>Los creadores publicaron más de 40 millones de experiencias durante el año.</p><h2>Robux generados</h2><p>Los creadores ganaron más de 700 millones de dólares a través de DevEx.</p>" \
    "Repasamos los números que convierten a Roblox en una de las plataformas más grandes del mundo." \
    "estadisticas-2024" "$NOTICIAS_ES" \
    "Roblox by the numbers: the most impressive statistics of 2024" \
    "<p>2024 was a record year for Roblox. We review the most striking statistics that demonstrate the platform's exponential growth.</p><h2>Active users</h2><p>Roblox surpassed 88 million daily active users, a 22% increase from 2023.</p><h2>Published games</h2><p>Creators published more than 40 million experiences during the year.</p><h2>Robux generated</h2><p>Creators earned more than 700 million dollars through DevEx.</p>" \
    "We review the numbers that make Roblox one of the largest platforms in the world." \
    "statistics-2024" "$NOTICIAS_EN" \
    "Roblox en chiffres : les statistiques les plus impressionnantes de 2024" \
    "<p>2024 a été une année record pour Roblox. Nous passons en revue les statistiques les plus frappantes qui démontrent la croissance exponentielle de la plateforme.</p><h2>Utilisateurs actifs</h2><p>Roblox a dépassé les 88 millions d'utilisateurs actifs quotidiens, une augmentation de 22% par rapport à 2023.</p><h2>Jeux publiés</h2><p>Les créateurs ont publié plus de 40 millions d'expériences au cours de l'année.</p>" \
    "Nous passons en revue les chiffres qui font de Roblox l'une des plus grandes plateformes au monde." \
    "statistiques-2024" "$NOTICIAS_FR"

# ─── 12. Limpieza final ───────────────────────────────────────────────────────
echo "Eliminando Post y Página de muestra de WordPress..."
$WP post delete 1 2>/dev/null || true  # Hello World
$WP post delete 2 2>/dev/null || true  # Sample Page

echo "Flush final de rewrite rules..."
$WP rewrite flush

echo ""
echo "======================================================"
echo " Setup completado exitosamente."
echo " Sitio: ${WP_HOME}"
echo " Admin: ${WP_HOME}/wp-admin"
echo " User:  ${WP_ADMIN_USER} / ${WP_ADMIN_PASSWORD}"
echo "======================================================"
