import wollok.game.*
import portadas.*
import music.*

/*ESTA CLASE NO LA ESTAMOS USANDO, capaz nos conviene hacerla en archivo aparte
class Nivel {
  method iniciar(){
  	//invasores.colocarEnemigos(){}
  	//game.addVisual(invasores)
  	//const enemigo = new Enemigo(x= 1, y= 11)
  	
  	//const arbusto = new Arbusto()
  	//const arbustosNivel1 = new Arbusto(arbustos = [arbusto])
  	//arbustos.colocarArbustos() --> Esto funciona pero los pone uno al lado del otro 
  	
  	/*
  	const enemigo = new Enemigo(position = game.at(0, 11))
  	const invasionNivel = new Invasion(invasores = [enemigo])
  	invasionNivel.iniciar() 
  	
  	//jugador.iniciar()
  }
}*/

class Personaje{
	//var property y 
	//var property position = game.at(x, y)
	//method puedeMover(pos) = pos.x().between(0, 30) and pos.y().between(0, 30)
	//var property x = 5 
	var property position = 0
	var property image
	var property vidas
	method iniciar(){game.addVisual(self)}
	method colocarEn(pos){position = game.at(pos.x(), pos.y())} 
	method moverSi(dir, condicion){
		if(condicion){self.mover(dir)}
	}
	method mover(dir){dir.moverA(self)}
	method recibirDisparo(){
		if(vidas == 1){game.removeVisual(self)}
		else{vidas -= 1}
	}
	method disparar()
}

class Enemigo inherits Personaje (vidas = 1, image = "carpincho45.png"){
	//var property imagen = "carpincho.png"
	var property direccion = derecha
	//override method iniciar(){}
	/*override method disparar(){
		const disp = new Disparo(x = self. x(), y = self.y()+1)
		game.addVisual(disp)
		disp.position(game.at(self.x(), disp.y()))
		game.onTick(100, "desplazarAbajo", {self.mover(abajo)})
	}*/
	override method iniciar(){
		super()
		game.onCollideDo(self, {x => self.recibirDisparo()})
		self.mover()
	}
	override method disparar(){}
	method decirVidas(){game.say(self, "Tengo " + vidas + " vidas.")} 
	method configurarAcciones(){
		keyboard.up().onPressDo{self.decirVidas()}
		keyboard.down().onPressDo{self.recibirDisparo()}
	}
	
//CODIGO DE PATRULLA DE LOS ENEMIGOS	
	method mover(){
		self.patrullarDerecha()
		game.onTick(20000, "patrullar", {self.cambiarDireccion()})
	}
	method patrullarDerecha(){
		game.onTick(1000,"Movimiento",{derecha.moverA(self)})
		//game.onTick(1000,"MovimientoDeAlien",{self.mover(derecha)})
	}
	method patrullarIzquierda(){
		game.onTick(1000,"Movimiento",{izquierda.moverA(self)})
		//game.onTick(1000,"MovimientoDeAlien",{self.mover(izquierda)})
	}
	method cambiarDireccion(){
		self.dejarDeMover()
		abajo.moverA(self)
		if (direccion.equals(derecha)){
			self.patrullarIzquierda()
			direccion=izquierda	
		}
		else {self.patrullarDerecha()
			  direccion=derecha
		}
	}
	method dejarDeMover(){
		game.removeTickEvent("Movimiento")
	}
}

object jugador inherits Personaje(vidas = 3, position = game.at(5,0), image = "casa.png"){
	/*override method disparar(){
		const disp = new Disparo(x = self. x(), y = self.y()+1)
		game.addVisual(disp)
		disp.position(game.at(self.x(), disp.y()))
		game.onTick(100, "desplazarArriba", {disp.mover(arriba)})
	}
	override method iniciar(){self.configurarAcciones()}*/
	override method disparar(){
		const disp = new Disparo()
		game.addVisual(disp)
		disp.colocarEn(self.position().up(1))
		game.onTick(100, "desplazarArriba", {disp.mover(arriba)})
		game.schedule(2000, {disp.desaparecer()})
		disp.colisionar()
	}
	override method iniciar(){
		super()
		game.onCollideDo(self, {x => self.recibirDisparo()})
		self.configurarAcciones()
	}
	method decirVidas(){game.say(self, "Tengo " + vidas + " vidas.")} 
	method configurarAcciones(){
		keyboard.left().onPressDo{self.mover(izquierda)}
		keyboard.right().onPressDo{self.mover(derecha)}
		keyboard.space().onPressDo{self.disparar()}
		keyboard.up().onPressDo{self.decirVidas()}
	}
}

//object invasion --> para el forEach
object invasion{
	const property invasores = []
	
	method iniciar(){}
	method enemigoRandom() = invasores.get(0.randomUpTo(invasores.size()))
	method disparoRandom(){self.enemigoRandom().disparar()}
	method atacar(){game.onTick(5000, "ataque", {self.disparoRandom()})}
	 
	method colocarFilaDeEnemigos(y){
		(1..12).forEach{x => self.aniadir(new Enemigo(position = game.at(x, y)))}
	}
	method aniadir(invasor){invasores.add(invasor)}
	method iniciarGrupo(){
		self.colocarFilaDeEnemigos(18)
		self.colocarFilaDeEnemigos(16)
		self.colocarFilaDeEnemigos(14)
		invasores.forEach({x=>x.iniciar()})
	}
}

class Disparo{
	//var property x
	//var property y=1
	/*method serDisparadaPor(personaje){personaje.disparar()}*/
	var property image = "disparo.png"
	var property position = null
	
	method desaparecer(){game.removeVisual(self)} 
	method mover(dir){dir.moverA(self)}
	method colocarEn(pos){position = game.at(pos.x(), pos.y())}
	method colisionar() {
		game.onCollideDo(self, {x => x.recibirDisparo()
		self.desaparecer()})
	}
}

class Arbusto{
	const property arbustos = []
	var property vidas = 5
	var property image = "cesped64px.png"
	var property position
	
	method iniciar(){
		game.addVisual(self)
		game.onCollideDo(self, {x => self.recibirDisparo()})
	}
	method recibirDisparo(){
		if(vidas == 1){game.removeVisual(self)}
		else{vidas -= 1}
		/* 
		if((vidas -=1).equals(4)){
			game.removeVisual(image = "5.png")
			game.addVisual(image = "4.png")
		}
		else if((vidas -=1).equals(3)){
			game.removeVisual(image = "4.png")
			game.addVisual(image = "3.png")
		}
		else if((vidas -=1).equals(2)){
			game.removeVisual(image = "3.png")
			game.addVisual(image = "2.png")
		}
		else if((vidas -=1).equals(1)){
			game.removeVisual(image = "2.png")
			game.addVisual(image = "1.png")
		}
		else{game.removeVisual(self)}*/
	}
}

//MOVIMIENTOS
object arriba{
	method moverA(personaje){
		if ((personaje.position().y()+1) > game.height()){
			game.removeVisual(personaje)}
		else{
			personaje.position(personaje.position().up(1))
		}
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
		if ((personaje.position().x()-1) < 0){
			personaje.position(game.at(29,0))}
		else{
			personaje.position(personaje.position().left(1))
		}
	}
}

object derecha{
	method moverA(personaje){
		if (personaje.position().x()+1 > 29){
				personaje.position(game.at(0,0))}
		else{
			personaje.position(personaje.position().right(1))
		}
	}
}