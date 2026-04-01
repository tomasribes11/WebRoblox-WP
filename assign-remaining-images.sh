#!/bin/bash

# Script para asignar imágenes únicas a posts restantes
# Posts 47-112

docker compose run --rm wp-cli wp post meta set 47 _thumbnail_id 133 --allow-root
docker compose run --rm wp-cli wp post meta set 55 _thumbnail_id 134 --allow-root
docker compose run --rm wp-cli wp post meta set 58 _thumbnail_id 135 --allow-root

# Posts de chat/traducción
docker compose run --rm wp-cli wp post meta set 43 _thumbnail_id 136 --allow-root
docker compose run --rm wp-cli wp post meta set 44 _thumbnail_id 137 --allow-root
docker compose run --rm wp-cli wp post meta set 45 _thumbnail_id 138 --allow-root

# Posts de eventos y actualizaciones
docker compose run --rm wp-cli wp post meta set 40 _thumbnail_id 139 --allow-root
docker compose run --rm wp-cli wp post meta set 41 _thumbnail_id 140 --allow-root
docker compose run --rm wp-cli wp post meta set 42 _thumbnail_id 141 --allow-root
docker compose run --rm wp-cli wp post meta set 34 _thumbnail_id 142 --allow-root
docker compose run --rm wp-cli wp post meta set 35 _thumbnail_id 143 --allow-root
docker compose run --rm wp-cli wp post meta set 36 _thumbnail_id 144 --allow-root

# Posts de motor gráfico
docker compose run --rm wp-cli wp post meta set 37 _thumbnail_id 145 --allow-root
docker compose run --rm wp-cli wp post meta set 38 _thumbnail_id 146 --allow-root
docker compose run --rm wp-cli wp post meta set 39 _thumbnail_id 147 --allow-root

# Posts de trabajo en equipo
docker compose run --rm wp-cli wp post meta set 31 _thumbnail_id 148 --allow-root
docker compose run --rm wp-cli wp post meta set 32 _thumbnail_id 127 --allow-root
docker compose run --rm wp-cli wp post meta set 33 _thumbnail_id 128 --allow-root

# Posts de diseño de mapas
docker compose run --rm wp-cli wp post meta set 28 _thumbnail_id 129 --allow-root
docker compose run --rm wp-cli wp post meta set 29 _thumbnail_id 130 --allow-root
docker compose run --rm wp-cli wp post meta set 30 _thumbnail_id 131 --allow-root

# Posts de monetización
docker compose run --rm wp-cli wp post meta set 25 _thumbnail_id 132 --allow-root
docker compose run --rm wp-cli wp post meta set 26 _thumbnail_id 133 --allow-root
docker compose run --rm wp-cli wp post meta set 27 _thumbnail_id 134 --allow-root

# Posts avanzados
docker compose run --rm wp-cli wp post meta set 108 _thumbnail_id 135 --allow-root
docker compose run --rm wp-cli wp post meta set 109 _thumbnail_id 136 --allow-root
docker compose run --rm wp-cli wp post meta set 110 _thumbnail_id 137 --allow-root
docker compose run --rm wp-cli wp post meta set 111 _thumbnail_id 138 --allow-root
docker compose run --rm wp-cli wp post meta set 112 _thumbnail_id 139 --allow-root

echo "Asignación de imágenes completada para todos los posts"
