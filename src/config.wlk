import wollok.game.*
import juego.*
//import portadas.*

object juego {
	method iniciar(){
		self.config()
		game.start()
	}
	
	method config(){
		self.ejecutarInicio()
		self.ejecutarPortadas()
		self.ejecutarPersonaje()
		self.ejecutarInvasores()
		self.ejecutarObjetos()
	}
	
	method ejecutarInicio(){
		game.title("Carpinchos Invaders")
		game.width(30)
		game.height(20)
		game.cellSize(32)
	}
	
	method ejecutarPortadas(){
		/*game.addVisual(inicio)
		keyboard.enter().onPressDo{}
		game.removeVisual(inicio)*/
		
		//-----game.addVisual(gameOver)
	}
	
	method ejecutarPersonaje(){
		game.addVisual(jugador)
		keyboard.left().onPressDo{jugador.mover(izquierda)}
		keyboard.right().onPressDo{jugador.mover(derecha)}
		keyboard.space().onPressDo{jugador.disparar()}
	}
	
	method ejecutarInvasores(){
		//lo tengo que corregir jsjsj
		const enemigo1 = new Enemigo(x=3, y=18)
		const enemigo2 = new Enemigo(x=6,y=18)
		const enemigo3 = new Enemigo(x=9,y=18)
		const enemigo4 = new Enemigo(x=12,y=18)
		const enemigo5 = new Enemigo(x=3,y=16)
		const enemigo6 = new Enemigo(x=6,y=16)
		const enemigo7 = new Enemigo(x=9,y=16)
		const enemigo8 = new Enemigo(x=12,y=16)
    	game.addVisual(enemigo1)
    	game.addVisual(enemigo2)
    	game.addVisual(enemigo3)
    	game.addVisual(enemigo4)
    	game.addVisual(enemigo5)
    	game.addVisual(enemigo6)
    	game.addVisual(enemigo7)
    	game.addVisual(enemigo8)
    	enemigo1.mover()
		enemigo2.mover()
		enemigo3.mover()
		enemigo4.mover()
		enemigo5.mover()
		enemigo6.mover()
		enemigo7.mover()
		enemigo8.mover()
    	/*game.whenCollideDo(enemigo1, {disparo => disparo.desaparecer()
		enemigo1.recibirDisparo()})
		game.whenCollideDo(enemigo2, {disparo => disparo.desaparecer()
		enemigo2.recibirDisparo()})
		game.whenCollideDo(enemigo3, {disparo => disparo.desaparecer()
		enemigo3.recibirDisparo()})*/
	}
	
	method ejecutarObjetos(){
		const arb1 = new Arbusto(x=2, y=2)
		const arb2 = new Arbusto(x=8, y=2)
		const arb3 = new Arbusto(x=14, y=2)
		const arb4 = new Arbusto(x=20, y=2)
		const arb5 = new Arbusto(x=26, y=2)
		game.addVisual(arb1)
		game.addVisual(arb2)
		game.addVisual(arb3)
		game.addVisual(arb4)
		game.addVisual(arb5)
	}
}