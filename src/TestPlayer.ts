
console.debug("TestPlayer - 0.0.2");

import { AVMPlayer } from "@awayfl/awayfl-player";
import { LoaderEvent } from "@awayjs/core"
import { AVMEvent } from '@awayfl/swf-loader';

class TestPlayer extends AVMPlayer {

	constructor(gameConfig: any) {
		super(gameConfig);

		if (!gameConfig.files || !gameConfig.files.length) {
			throw ("AVMPlayer: gameConfig.files must have positive length");
		}

		if (this._gameConfig.showFPS) {
			this.showFrameRate = true;
		}

		this.addEventListener(LoaderEvent.LOADER_COMPLETE, (event) => {
			if (!this._gameConfig.start) {
				if (window["loaderComplete"])
					window["loaderComplete"]();
				this.play(gameConfig.skipFramesOfScene);
				return;
			}
			if (window["loaderComplete"])
				window["loaderComplete"](() => this.play(gameConfig.skipFramesOfScene));
		});

		this.load();

	}

	protected onAVMAvailable(event: AVMEvent) {

	}
}

window["AVMPlayerClass"] = TestPlayer;
