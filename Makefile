enter-wg:
	cd scripts && ./build-xray.sh enter wg
	cd builds/enter && docker compose up -d --build

enter-reality:
	cd scripts && ./build-xray.sh enter reality
	cd builds/enter && docker compose up -d --build

exit:
	cd scripts && ./build-xray.sh exit
	cd builds/exit && docker compose up -d --build

restart-enter:
	cd builds/enter && docker compose restart

restart-exit:
	cd builds/exit && docker compose restart