#!/bin/bash

# Script para asignar imágenes únicas de Roblox y tecnología a posts
# Imágenes descargadas y asignadas según contenido del artículo

echo "Importando nuevas imágenes de Roblox y tecnología..."
docker compose run --rm wp-cli wp media import temp-images/roblox-gameplay-1.jpg --allow-root
docker compose run --rm wp-cli wp media import temp-images/roblox-avatar.jpg --allow-root
docker compose run --rm wp-cli wp media import temp-images/roblox-coin.jpg --allow-root
docker compose run --rm wp-cli wp media import temp-images/coding-screen.jpg --allow-root
docker compose run --rm wp-cli wp media import temp-images/cyber-security.jpg --allow-root
docker compose run --rm wp-cli wp media import temp-images/lua-coding.jpg --allow-root
docker compose run --rm wp-cli wp media import temp-images/roblox-studio.jpg --allow-root
docker compose run --rm wp-cli wp media import temp-images/programmer-code.jpg --allow-root
docker compose run --rm wp-cli wp media import temp-images/ai-technology.jpg --allow-root
docker compose run --rm wp-cli wp media import temp-images/team-gaming.jpg --allow-root

echo "Asignando imágenes específicas según contenido..."

# Artículos sobre Robux y monetización - imágenes de Robux/monedas
docker compose run --rm wp-cli wp post meta set 4 _thumbnail_id 133 --allow-root  # 5 trucos secretos para conseguir Robux rápido
docker compose run --rm wp-cli wp post meta set 5 _thumbnail_id 133 --allow-root  # 5 secret tricks to get Robux fast
docker compose run --rm wp-cli wp post meta set 6 _thumbnail_id 133 --allow-root  # 5 astuces secrètes pour obtenir des Robux rapidement
docker compose run --rm wp-cli wp post meta set 25 _thumbnail_id 133 --allow-root  # Guía de monetización: cómo ganar dinero real con tus juegos
docker compose run --rm wp-cli wp post meta set 26 _thumbnail_id 133 --allow-root  # Monetization guide: how to earn real money with your games
docker compose run --rm wp-cli wp post meta set 27 _thumbnail_id 133 --allow-root  # Guide de monétisation : comment gagner de l'argent réel avec vos jeux
docker compose run --rm wp-cli wp post meta set 109 _thumbnail_id 133 --allow-root # Guía de Monetización: Cómo Ganar Robux con tus Juegos

# Artículos sobre seguridad - imágenes de ciberseguridad
docker compose run --rm wp-cli wp post meta set 16 _thumbnail_id 134 --allow-root # 5 formas de proteger tu cuenta de Roblox de los hackers
docker compose run --rm wp-cli wp post meta set 17 _thumbnail_id 134 --allow-root # 5 ways to protect your Roblox account from hackers
docker compose run --rm wp-cli wp post meta set 18 _thumbnail_id 134 --allow-root # 5 façons de protéger votre compte Roblox des pirates
docker compose run --rm wp-cli wp post meta set 112 _thumbnail_id 134 --allow-root # Roblox Security: Protecting Your Account and Games

# Artículos sobre programación y scripting - imágenes de código
docker compose run --rm wp-cli wp post meta set 22 _thumbnail_id 135 --allow-root # Introducción a Lua: programa tu primer script en Roblox
docker compose run --rm wp-cli wp post meta set 23 _thumbnail_id 135 --allow-root # Introduction to Lua: program your first script in Roblox
docker compose run --rm wp-cli wp post meta set 24 _thumbnail_id 135 --allow-root # Introduction à Lua : programmez votre premier script sur Roblox
docker compose run --rm wp-cli wp post meta set 108 _thumbnail_id 135 --allow-root # Advanced Lua Scripting: Creating Custom Game Mechanics
docker compose run --rm wp-cli wp post meta set 111 _thumbnail_id 135 --allow-root # Scripting Avanzado: Técnicas Profesionales para Roblox Studio

# Artículos sobre avatar y personalización - imágenes de avatar
docker compose run --rm wp-cli wp post meta set 7 _thumbnail_id 136 --allow-root  # Cómo personalizar tu avatar al máximo en Roblox
docker compose run --rm wp-cli wp post meta set 8 _thumbnail_id 136 --allow-root  # How to fully customize your avatar in Roblox
docker compose run --rm wp-cli wp post meta set 9 _thumbnail_id 136 --allow-root  # Comment personnaliser votre avatar au maximum sur Roblox

# Artículos sobre creación de juegos y mapas - imágenes de Roblox Studio
docker compose run --rm wp-cli wp post meta set 19 _thumbnail_id 137 --allow-root # Guía completa para crear tu primer juego en Roblox Studio
docker compose run --rm wp-cli wp post meta set 20 _thumbnail_id 137 --allow-root # Complete guide to creating your first game in Roblox Studio
docker compose run --rm wp-cli wp post meta set 21 _thumbnail_id 137 --allow-root # Guide complète pour créer votre premier jeu dans Roblox Studio
docker compose run --rm wp-cli wp post meta set 28 _thumbnail_id 137 --allow-root # Cómo diseñar mapas atractivos que enganchen a los jugadores
docker compose run --rm wp-cli wp post meta set 29 _thumbnail_id 137 --allow-root # How to design attractive maps that keep players hooked
docker compose run --rm wp-cli wp post meta set 30 _thumbnail_id 137 --allow-root # Comment concevoir des cartes attrayantes qui accrochent les joueurs
docker compose run --rm wp-cli wp post meta set 110 _thumbnail_id 137 --allow-root # Map Design Mastery: Creating Immersive Roblox Worlds

# Artículos sobre colaboración y trabajo en equipo - imágenes de equipo gaming
docker compose run --rm wp-cli wp post meta set 31 _thumbnail_id 138 --allow-root # Trabaja en equipo: colaboración efectiva en proyectos de Roblox
docker compose run --rm wp-cli wp post meta set 32 _thumbnail_id 138 --allow-root # Teamwork: effective collaboration on Roblox projects
docker compose run --rm wp-cli wp post meta set 33 _thumbnail_id 138 --allow-root # Travail d'équipe : collaboration efficace sur les projets Roblox

# Artículos sobre controles y teclado - imágenes de gaming setup
docker compose run --rm wp-cli wp post meta set 10 _thumbnail_id 139 --allow-root # Todos los controles y atajos de teclado que debes conocer
docker compose run --rm wp-cli wp post meta set 11 _thumbnail_id 139 --allow-root # All keyboard controls and shortcuts you need to know
docker compose run --rm wp-cli wp post meta set 12 _thumbnail_id 139 --allow-root # Tous les contrôles clavier et raccourcis que vous devez connaître

# Artículos sobre grupos - imágenes de gameplay/team gaming
docker compose run --rm wp-cli wp post meta set 13 _thumbnail_id 140 --allow-root # Cómo unirte a grupos y sacarles el máximo partido
docker compose run --rm wp-cli wp post meta set 14 _thumbnail_id 140 --allow-root # How to join groups and get the most out of them
docker compose run --rm wp-cli wp post meta set 15 _thumbnail_id 140 --allow-root # Comment rejoindre des groupes et en tirer le maximum

# Artículos sobre estadísticas y números - imágenes de tecnología/IA
docker compose run --rm wp-cli wp post meta set 47 _thumbnail_id 141 --allow-root # Roblox by the numbers: the most impressive statistics of 2024
docker compose run --rm wp-cli wp post meta set 55 _thumbnail_id 141 --allow-root # Roblox en números: las estadísticas más impresionantes de 2024
docker compose run --rm wp-cli wp post meta set 58 _thumbnail_id 141 --allow-root # Roblox en chiffres : les statistiques les plus impressionnantes de 2024

# Artículos sobre chat y traducción - imágenes de tecnología
docker compose run --rm wp-cli wp post meta set 43 _thumbnail_id 142 --allow-root # Roblox mejora el sistema de chat con traducción automática en tiempo real
docker compose run --rm wp-cli wp post meta set 44 _thumbnail_id 142 --allow-root # Roblox improves the chat system with real-time automatic translation
docker compose run --rm wp-cli wp post meta set 45 _thumbnail_id 142 --allow-root # Roblox améliore le système de chat avec la traduction automatique en temps réel

# Artículos sobre motor gráfico - imágenes de tecnología/IA
docker compose run --rm wp-cli wp post meta set 37 _thumbnail_id 143 --allow-root # Roblox actualiza su motor gráfico: así lucirán los juegos en 2025
docker compose run --rm wp-cli wp post meta set 38 _thumbnail_id 143 --allow-root # Roblox updates its graphics engine: here's how games will look in 2025
docker compose run --rm wp-cli wp post meta set 39 _thumbnail_id 143 --allow-root # Roblox met à jour son moteur graphique : voici à quoi ressembleront les jeux en 2025

# Artículos sobre eventos y temporadas - imágenes de gameplay
docker compose run --rm wp-cli wp post meta set 34 _thumbnail_id 144 --allow-root # Nueva temporada 2025: todo lo que llega a Roblox este mes
docker compose run --rm wp-cli wp post meta set 35 _thumbnail_id 144 --allow-root # New 2025 season: everything coming to Roblox this month
docker compose run --rm wp-cli wp post meta set 36 _thumbnail_id 144 --allow-root # Nouvelle saison 2025 : tout ce qui arrive sur Roblox ce mois-ci

# Artículos sobre eventos ecológicos - imágenes de tecnología/programación
docker compose run --rm wp-cli wp post meta set 40 _thumbnail_id 145 --allow-root # Evento especial: Roblox celebra el Día de la Tierra con juegos ecológicos
docker compose run --rm wp-cli wp post meta set 41 _thumbnail_id 145 --allow-root # Special event: Roblox celebrates Earth Day with eco-friendly games
docker compose run --rm wp-cli wp post meta set 42 _thumbnail_id 145 --allow-root # Événement spécial : Roblox célèbre le Jour de la Terre avec des jeux écologiques

echo "Asignación de imágenes completada. Todos los posts ahora tienen imágenes únicas de Roblox o tecnología."
