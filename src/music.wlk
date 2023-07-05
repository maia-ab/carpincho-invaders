import wollok.game.*
import juego.*
import niveles.*

class Music{
	var property music
	method play(){
		game.schedule(500, {music.play()})
		keyboard.p().onPressDo({music.pause()})
		keyboard.r().onPressDo({music.resume()})
	}
	method stop(){music.stop()}
}

object soundPrincipal inherits Music(music = game.sound("principal.mp3")){
	override method play(){
		super()
		music.shouldLoop(true)
	}
}
const soundVictoria  = new Music(music = game.sound("victoria.mp3"))
const soundGameOver = new Music(music = game.sound("gameOver.mp3"))