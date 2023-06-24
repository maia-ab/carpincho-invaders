import wollok.game.*
import juego.*
import portadas.*
import music.*
import niveles.*
import visuales.*

object juego {
	method iniciarJuego(){
		self.config()
		game.start()
	}
	method config(){
		self.configVentana()
		nivel1.iniciar()
		//niveles.ejecutarPartida()
		menu.ejecutar()
		inicio.ejecutar()
	}
	method configVentana(){
		game.title("Carpinchos Invaders")	
		game.width(30)
		game.height(20)
		game.cellSize(32)
	}
}