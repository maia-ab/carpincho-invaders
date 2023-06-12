import wollok.game.*

class Nivel {
  method iniciar(){
  	//invasores.colocarEnemigos(){}
  	//game.addVisual(invasores)
  	//const enemigo = new Enemigo(x= 1, y= 11)
  	
  	//const arbusto = new Arbusto()
  	//const arbustosNivel1 = new Arbusto(arbustos = [arbusto])
  	//arbustos.colocarArbustos() --> Esto funciona pero los pone uno al lado del otro 
  	
  	const enemigo = new Enemigo(position = game.at(5, 11))
  	const invasionNivel = new Invasion(invasores = [enemigo])
  	//invasion.colocarEnemigos() --> Esto funciona pero los pone uno al lado del otro 
  	
  	invasionNivel.iniciar()
  	jugador.iniciar()
  }
}

//object invasion --> Para usar el forEach
class Invasion{
	const property invasores = []
	
	method iniciar(){}
	method enemigoRandom() = invasores.get(0.randomUpTo(invasores.size()))
	method disparoRandom(){self.enemigoRandom().disparar()}
	method atacar(){game.onTick(5000, "ataque", {self.disparoRandom()})}
	/* 
	method colocarEnemigos(){
		(1..11).forEach{x => self.aniadir(new Enemigo(position = game.at(x, 11)))}
	}
	method aniadir(invasor){
		invasores.add(invasor)
		game.addVisual(invasor)
	}*/
}

class Personaje{
	//var property y 
	//var property position = game.at(x, y)
	//method puedeMover(pos) = pos.x().between(0, 30) and pos.y().between(0, 30)
	var property x = 5 
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

class Enemigo inherits Personaje (vidas = 1, position = game.at(5, 11), image = "carpincho.png"){
	//var property imagen = "carpincho.png"
	//var property direccion = derecha
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
	}
	override method disparar(){}
	method decirVidas(){game.say(self, "Tengo " + vidas + " vidas.")} 
	method configurarAcciones(){
		keyboard.up().onPressDo{self.decirVidas()}
		keyboard.down().onPressDo{self.recibirDisparo()}
	}
	
//CODIGO DE PATRULLA DE LOS ENEMIGOS	
	/*method mover(){
		self.patrullarDerecha()
		game.onTick(7000, "patrullar", {self.cambiarDireccion()})
	}
	method patrullarDerecha(){
		//game.onTick(1000,"MovimientoDeAlien",{self.moveteDerecha()})
		game.onTick(1000,"Movimiento",{derecha.moverA(self)})
		//game.onTick(1000,"MovimientoDeAlien",{self.mover(derecha)})
	}
	method patrullarIzquierda(){
		//game.onTick(1000,"MovimientoDeAlien",{self.moveteIzquierda()})
		game.onTick(1000,"Movimiento",{izquierda.moverA(self)})
		//game.onTick(1000,"MovimientoDeAlien",{self.mover(izquierda)})
	}
	method cambiarDireccion(){
		self.dejarDeMover()
		self.mover(abajo)
		if (direccion.equals(derecha)){self.patrullarIzquierda()}
		else {self.patrullarDerecha()}
	}
	method dejarDeMover(){
		game.removeTickEvent("Movimiento")
	}*/
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

class Disparo{
	//var property x
	var property y=1
	var property image = "disparo.png"
	var property position = null
	method desaparecer(){game.removeVisual(self)} 
	/*method serDisparadaPor(personaje){personaje.disparar()}*/
	method mover(dir){dir.moverA(self)}
	method colocarEn(pos){position = game.at(pos.x(), pos.y())}
}



class Arbusto{
	var property vidas = 5
	var property image = "cesped64px.png"
	var property position
	method recibirDisparo(){
		if(vidas == 1){game.removeVisual(self)}
		else{vidas -= 1}
	}
	method iniciar(){
		game.addVisual(self)
		game.onCollideDo(self, {x => self.recibirDisparo()})
	}
	
	//--------------------------------------------------------------
	/* var property x = null
	var property image
	var property position = null
	method colocarEn(pos){position = game.at(pos.x(), pos.y())}*/
}

/* 
object arbustos{
	const property arbustos = []
	var property x = null
	method colocarArbustos(){
		(2..10).forEach{a => self.aniadir(new Arbusto(position = game.at(x, 2), image = "cesped32px.png"))}
	}
	method aniadir(arbusto){
		arbustos.add(arbusto)
		game.addVisual(arbusto)
	}
}*/

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
		personaje.x(personaje.x()-1)
		if(personaje.x()<0){
			personaje.position(game.at(30,0))
			personaje.x(30)
		}else{
			personaje.position(personaje.position().left(1))
		}
	}
}
object derecha{
	method moverA(personaje){
		personaje.position( personaje.position().right(1))
		personaje.x(personaje.x()+1)
		if(personaje.x()>=30){
				personaje.position(game.at(0,0))
				personaje.x(0)
			}
	}
}
