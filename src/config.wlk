import wollok.game.*
import juego.*
import portadas.*

object juego {
	method iniciar(){
		self.config()
		game.start()
	}
	
	method config(){
		self.configInicio()
		self.configPersonaje()
		self.configInvasores()
		self.ejecutarObjetos()
		inicio.ejecutar()
	}
	
	method configInicio(){
		//game.boardGround("arena.png")
		game.title("Carpinchos Invaders")
		game.width(30)
		game.height(20)
		game.cellSize(32)
	}
	
	method configPersonaje(){
		/*game.addVisual(jugador)
		keyboard.left().onPressDo{jugador.mover(izquierda)}
		keyboard.right().onPressDo{jugador.mover(derecha)}
		keyboard.space().onPressDo{jugador.disparar()}*/
		jugador.iniciar()
	}
	
	method configInvasores(){
		const enemigo1 = new Enemigo()
		enemigo1.iniciar()
		
		
		//invasion.colocarEnemigos() --> Es del forEach
		
		
		/*const enemigo2 = new Enemigo(x=6,y=18)
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
		enemigo8.mover()*/
    	/*game.whenCollideDo(enemigo1, {disparo => disparo.desaparecer()
		enemigo1.recibirDisparo()})
		game.whenCollideDo(enemigo2, {disparo => disparo.desaparecer()
		enemigo2.recibirDisparo()})
		game.whenCollideDo(enemigo3, {disparo => disparo.desaparecer()
		enemigo3.recibirDisparo()})*/
	}
	
	method ejecutarObjetos(){
		//arbustos.colocarArbustos() --> Es del forEach
		const arb1 = new Arbusto(position = game.at(2,2))
		const arb2 = new Arbusto(position = game.at(8,2))
		const arb3 = new Arbusto(position = game.at(14,2))
		const arb4 = new Arbusto(position = game.at(20,2))
		const arb5 = new Arbusto(position = game.at(26,2))
		arb1.iniciar()
		arb2.iniciar() 
		arb3.iniciar() 
		arb4.iniciar() 
		arb5.iniciar() 
	}
}