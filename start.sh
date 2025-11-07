#!/bin/bash
# filepath: /home/tom/Depotgit/42-ft_onion/start.sh
set -e

echo "🔧 Vérification des permissions..."
chown -R debian-tor:debian-tor /var/lib/tor
chmod 700 /var/lib/tor/hidden_service

echo "🔑 Démarrage du serveur SSH..."
/usr/sbin/sshd

echo "🚀 Démarrage de Nginx..."
service nginx start

echo "🧅 Démarrage de Tor..."
su -s /bin/bash debian-tor -c "tor -f /etc/tor/torrc &"

echo "⏳ Attente de la génération de l'adresse .onion..."
sleep 10

if [ -f /var/lib/tor/hidden_service/hostname ]; then
	echo "✅ Adresse Onion générée :"
	cat /var/lib/tor/hidden_service/hostname
	echo "🌍 Service web Tor prêt !"
else
	echo "❌ Erreur: Impossible de générer l'adresse .onion"
fi

echo "🔗 Serveur SSH prêt sur le port 4242"
echo "📊 Logs Nginx:"
tail -f /var/log/nginx/access.log /var/log/nginx/error.log