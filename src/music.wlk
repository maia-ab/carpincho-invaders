import wollok.game.*
import juego.*

const musicPrincipal = game.sound("principal.mp3")
const musicVictoria = game.sound("victoria.mp3")
const musicGameOver = game.sound("gameOver.mp3")

object sound{
	//const property music = game.sound("principal.mp3")
	//const property musicVictoria = game.sound("victoria.mp3")
	//const property musicGameOver = game.sound("gameOver.mp3")
	
	method musicConfig(pista){
		keyboard.p().onPressDo(
			if(pista.paused()){pista.resume()}
			else{pista.pause()}
		)
		keyboard.up().onPressDo({pista.volume(1)})
		keyboard.down().onPressDo({pista.volume(0)})
	}
}