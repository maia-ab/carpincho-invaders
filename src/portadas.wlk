import wollok.game.*
import juego.*
import music.*
import niveles.*
import visuales.*

class Visual{
	var property position = game.at(0,0)
	var property image
	method ejecutar(){game.addVisual(self)}
	method remover(){game.removeVisual(self)}
}

object inicio inherits Visual(image = "inicio.png"){
	override method ejecutar(){
		super()
		game.schedule(4000,{self.remover()})
	}
}
 
object menu inherits Visual(image = "menu.png"){
	const property ajustes = new Visual(image = "ajustes.png")
	
	override method ejecutar(){
		super()
		soundPrincipal.play()
		keyboard.enter().onPressDo{
			game.clear()
			nivel1.iniciar()
			//self.remover() ULTIMO
			//invasion.atacar() ULTIMO
		} //CAMBIO
		keyboard.a().onPressDo({self.setting()})
	}
	method setting(){
		game.addVisual(ajustes)
		keyboard.backspace().onPressDo{game.removeVisual(ajustes)}
	}
}

object victoria inherits Visual(image = "victoria.png"){
	override method ejecutar(){
		super()
		soundPrincipal.stop()
		soundVictoria.play()
		keyboard.r().onPressDo{self.siguientePartida()}
	}
	method siguientePartida(){}
}

object gameOver inherits Visual(image = "gameOver.png"){
	override method ejecutar(){
		super()
		soundPrincipal.stop()
		soundGameOver.play()
		game.schedule(5000,{game.stop()})
	}
}
