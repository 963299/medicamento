#!/usr/bin/env bash
# Ajustes no projeto Android gerado pelo "npx cap add android".
set -euo pipefail
RES=android/app/src/main/res
MANIFEST=android/app/src/main/AndroidManifest.xml

# 1) Permissões extras (o plugin já traz POST_NOTIFICATIONS, SCHEDULE_EXACT_ALARM, WAKE_LOCK e BOOT_COMPLETED)
sed -i 's#<uses-permission android:name="android.permission.INTERNET" />#<uses-permission android:name="android.permission.INTERNET" />\n    <uses-permission android:name="android.permission.VIBRATE" />\n    <uses-permission android:name="android.permission.USE_EXACT_ALARM" />#' "$MANIFEST"
grep -q "USE_EXACT_ALARM" "$MANIFEST"

# 2) Ícone pequeno da notificação (barra de status)
mkdir -p "$RES/drawable"
cp native/ic_stat_icon.xml "$RES/drawable/ic_stat_icon.xml"

# 3) Ícone do app = o ícone do MEDICAMENTO (substitui o logo do Capacitor)
rm -rf "$RES/mipmap-anydpi-v26"
for pair in mdpi:48 hdpi:72 xhdpi:96 xxhdpi:144 xxxhdpi:192; do
  d="${pair%%:*}"; s="${pair##*:}"
  rm -f "$RES/mipmap-$d/ic_launcher_foreground.png"
  convert icons/icon-512.png -resize "${s}x${s}" "$RES/mipmap-$d/ic_launcher.png"
  cp "$RES/mipmap-$d/ic_launcher.png" "$RES/mipmap-$d/ic_launcher_round.png"
done

# 4) Tela de abertura: fundo escuro liso (em vez do logo do Capacitor)
find "$RES" -name splash.png | while read -r f; do
  convert -size "$(identify -format '%wx%h' "$f")" xc:'#0A0E16' "$f"
done

# 5) versionCode crescente: cada build novo atualiza o app instalado sem desinstalar
sed -i "s/versionCode 1/versionCode ${GITHUB_RUN_NUMBER:-1}/" android/app/build.gradle

# 6) Chave de assinatura fixa (mesma em todo build)
mkdir -p "$HOME/.android"
cp native/debug.keystore "$HOME/.android/debug.keystore"
echo "Ajustes aplicados."
