import wollok.game.*
import juego.*
import music.*

class Visual{
	var property position = game.at(0,0)
	var property image
	//var property soundAReproducir
	method ejecutar(){game.addVisual(self)}
	method remover(){game.removeVisual(self)}
}

object inicio inherits Visual(image = "inicio.png"){
	override method ejecutar(){
		super()
		game.schedule(5000,{self.remover()})
	}
}
 
object menu inherits Visual(image = "menu.png"){
	const property reglas = new Visual(image = "reglas.png")
	const property ajustes = new Visual(image = "ajustes.png")
	
	override method ejecutar(){
		//sound.musicConfig(self.soundAReproducir())
		//musicPrincipal.shouldLoop(true)
		super()
		keyboard.enter().onPressDo{self.remover()}
		keyboard.i().onPressDo({self.ejecutarReglas()})
		keyboard.a().onPressDo({self.setting()})
	}
	method ejecutarReglas(){
		game.addVisual(reglas)
		keyboard.backspace().onPressDo{game.removeVisual(reglas)}
	}
	method setting(){
		game.addVisual(ajustes)
		keyboard.backspace().onPressDo{game.removeVisual(ajustes)}
		keyboard.r().onPressDo{game.removeVisual(ajustes)}
		keyboard.p().onPressDo{game.removeVisual(ajustes)}
	}
}

object victoria inherits Visual(image = "victoria.png"){
	override method ejecutar(){
		super()
		//if(){} 
		//sound.musicConfig(musicVictoria.play())
		keyboard.r().onPressDo{self.siguientePartida()}
	}
	method siguientePartida(){}
}

object gameOver inherits Visual(image = "gameOver.png"){
	override method ejecutar(){
		super()
		//if(){}  
		//sound.musicConfig(musicGameOver.play())
		keyboard.control().onPressDo{self.volverAInicio()}
	}
	method volverAInicio(){}
}

