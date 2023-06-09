import wollok.game.*

class Nivel {
  method iniciar(){
  	const enemigo = new Enemigo(x= 1, y= 11)
  	const invasionNivel = new Invasion(invasores = [enemigo])
  	invasionNivel.iniciar()
  	jugador.iniciar()
  }
}



class Invasion{
	const property invasores = []
	//method colocarFilaDeEnemigos(){
	//	(1..13).forEach { x => toni.sembrar(new Maiz(position= game.at(x, 5)))}
	//}
	method iniciar(){}
	method enemigoRandom() = invasores.get(0.randomUpTo(invasores.size()))
	method disparoRandom(){
		self.enemigoRandom().disparar()
	}
	method atacar(){
		game.onTick(5000, "ataque", {self.disparoRandom()})
	}
}


class Personaje{
	var property x 
	var property y 
	var property position = game.at(x, y)
	var property image = "alien.png"
	var property vidas
	method iniciar()
	//method puedeMover(pos) = pos.x().between(0, game.width()) and pos.y().between(0, game.height())
	method colocarEn(pos){
		position = game.at(x, y)
	} 
	method moverSi(dir, condicion){
		if (condicion){
			self.mover(dir)
		}
	}
	method mover(dir){
		dir.moverA(self)	
	}
	method recibirDisparo(){vidas -= 1}
	method disparar()
}



class Enemigo inherits Personaje (vidas = 1){
	override method iniciar(){}
	override method disparar(){
		const disp = new Disparo(x = self. x(), y = self.y()+1)
		game.addVisual(disp)
		disp.position(game.at(self.x(), disp.y()))
		game.onTick(100, "desplazarAbajo", {self.mover(abajo)})
	}
}

object jugador inherits Personaje(x=5, y= 0, vidas = 3){
	override method disparar(){
		const disp = new Disparo(x = self. x(), y = self.y()+1)
		game.addVisual(disp)
		disp.position(game.at(self.x(), disp.y()))
		//game.onTick(100, "desplazarArriba", {disp.moverSi(arriba, self.puedeMover(y = self.y()+1))})
		game.onTick(100, "desplazarArriba", {disp.mover(arriba)})
	}
	override method iniciar(){self.configurarAcciones()}
	method configurarAcciones(){
		keyboard.left().onPressDo{self.mover(izquierda)}
		keyboard.right().onPressDo{self.mover(derecha)}
		keyboard.space().onPressDo{self.disparar()}
	}
}

class Disparo{
	var property image = "pepita.png"
	var property x
	var property y  
	var property position = null
	method mover(dir){
		dir.moverA(self)	
	}
}


//DIRECCIONES
object arriba{
	method moverA(personaje){
		personaje.position( personaje.position().up(1))
		personaje.y(personaje.y()+1)
	}
}

object abajo{
	method moverA(personaje){
		personaje.position( personaje.position().down(1))
		personaje.y(personaje.y()-1)
	}
}
object izquierda{
	method moverA(personaje){
		personaje.position( personaje.position().left(1))
		personaje.x(personaje.x()-1)
	}
}
object derecha{
	method moverA(personaje){
		personaje.position( personaje.position().right(1))
		personaje.x(personaje.x()+1)
	}
}

