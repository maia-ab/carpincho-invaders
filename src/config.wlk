import wollok.game.*
import juego.*
import portadas.*
import music.*

object juego {
	method iniciar(){
		self.config()
		game.start()
	}
	
	method config(){
		self.nivel1()
		self.configInicio()
		self.configPersonaje()
		self.configInvasores()
		self.ejecutarObjetos()
		menu.ejecutar()
		inicio.ejecutar()
	}
	
	method configInicio(){
		game.title("Carpinchos Invaders")	
		game.width(30)
		game.height(20)
		game.cellSize(32)
	}
	
	method configPersonaje(){
		jugador.iniciar()
	}
	
	method configInvasores(){
		/* 
		const enemigo1 = new Enemigo(position = game.at(3, 11))
		const enemigo2 = new Enemigo(position = game.at(3, 12))
		const enemigo3 = new Enemigo(position = game.at(5, 11))
		const enemigo4 = new Enemigo(position = game.at(5, 12))
		const enemigo5 = new Enemigo(position = game.at(7, 11))
		const enemigo6 = new Enemigo(position = game.at(7, 12))
		const enemigo7 = new Enemigo(position = game.at(1, 11))
		const enemigo8 = new Enemigo(position = game.at(1, 12))
		const enemigos=[enemigo1,enemigo2,enemigo3,enemigo4,enemigo5,enemigo6,enemigo7,enemigo8]
		enemigos.forEach({x=>x.iniciar()})*/	
		//for each 
		invasion.iniciarGrupo()	
	}
	
	method ejecutarObjetos(){
		const arb1 = new Arbusto(position = game.at(2,3))
		const arb2 = new Arbusto(position = game.at(8,3))
		const arb3 = new Arbusto(position = game.at(14,3))
		const arb4 = new Arbusto(position = game.at(20,3))
		const arb5 = new Arbusto(position = game.at(26,3))
		arb1.iniciar()
		arb2.iniciar() 
		arb3.iniciar() 
		arb4.iniciar() 
		arb5.iniciar() 
	}
	
	method nivel1(){
		game.boardGround("nivel1.png")
	}
}