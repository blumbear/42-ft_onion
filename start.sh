#!/bin/bash
set -e

echo "🔧 Vérification des permissions..."
chown -R debian-tor:debian-tor /var/lib/tor
chmod 700 /var/lib/tor/hidden_service

echo "🚀 Démarrage de Nginx..."
service nginx start

echo "🧅 Démarrage de Tor..."
# Lancer Tor sous l'utilisateur debian-tor
su -s /bin/bash debian-tor -c "tor -f /etc/tor/torrc &"

echo "⏳ Attente de la génération de l'adresse .onion..."
sleep 5

if [ -f /var/lib/tor/hidden_service/hostname ]; then
	echo "✅ Adresse Onion générée :"
	cat /var/lib/tor/hidden_service/hostname
else
	echo "❌ Erreur : le fichier hostname n'a pas été généré."
	exit 1
fi

echo "🌍 Service web Tor prêt !"
tail -f /var/log/nginx/access.log /var/log/nginx/error.log
