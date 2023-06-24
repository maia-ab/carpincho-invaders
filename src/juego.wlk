import wollok.game.*
import portadas.*
import music.*
import niveles.*
import visuales.*

class Personaje{
	//var property y 
	//var property position = game.at(x, y)
	//method puedeMover(pos) = pos.x().between(0, 30) and pos.y().between(0, 30)
	//var property x = 5 
	var property puedeDisparar=true
	var property position = 0
	var property image
	var property vidas
	method iniciar(){game.addVisual(self)}
	method colocarEn(pos){position = game.at(pos.x(), pos.y())} 
	method moverSi(dir, condicion){if(condicion){self.mover(dir)}}
	method sePuedeMoverA(dir) = dir.puedeMoverse(self)
	method mover(dir){dir.moverA(self)}
	method recibirDisparo(){
		if(vidas == 1){game.removeVisual(self)}
		else{vidas -= 1}
	}
	method disparar(dir)
}


object jugador inherits Personaje(vidas = 3, position = game.at(5,0), image = "casa.png"){
	/*override method disparar(){
		const disp = new Disparo(x = self. x(), y = self.y()+1)
		game.addVisual(disp)
		disp.position(game.at(self.x(), disp.y()))
		game.onTick(100, "desplazarArriba", {disp.mover(arriba)})
	}
	override method iniciar(){self.configurarAcciones()}*/
	var property vida1=new Vida(position=game.at(0,19))
	var property vida2=new Vida(position=game.at(1,19))
	var property vida3=new Vida(position=game.at(2,19))
	override method disparar(dir){
		const disp = new Disparo(position = self.position().up(1))
		if(puedeDisparar){
			disp.serDisparadoPor(self, dir)
			puedeDisparar=false
			game.schedule(1500,{puedeDisparar=true})
		}
	}
	override method recibirDisparo(){
		if(vidas == 0){game.removeVisual(self)
					   gameOver.ejecutar()
					   puedeDisparar=false
					   
		}else{
			if(vidas==1){
				game.removeVisual(vida1)
				vidas -= 1
			}else{
				if(vidas==2){
					game.removeVisual(vida2)
					vidas -= 1
				}else{
					game.removeVisual(vida3)
					vidas -= 1
				}
			}
		}
	}
	override method iniciar(){
		super()
		self.configurarAcciones()
	}
	//method decirVidas(){game.say(self, "Tengo " + vidas + " vidas.")} 
	method configurarAcciones(){
		keyboard.left().onPressDo{self.mover(izquierda)}
		keyboard.right().onPressDo{self.mover(derecha)}
		keyboard.space().onPressDo{self.disparar(arriba)}
		game.addVisual(vida1)
		game.addVisual(vida2)
		game.addVisual(vida3)
		//keyboard.up().onPressDo{self.decirVidas()}
		
	}
}

class Vida{
	var property position
	var property image= "vida.png"
}

class Enemigo inherits Personaje (vidas = 1, image = "carpincho45.png"){
	//override method iniciar(){}
	/*override method disparar(){
		const disp = new Disparo(x = self. x(), y = self.y()+1)
		game.addVisual(disp)
		disp.position(game.at(self.x(), disp.y()))
		game.onTick(100, "desplazarAbajo", {self.mover(abajo)})
	}*/
	var property direccion = derecha
	
	override method iniciar(){
		super()
		game.onCollideDo(self, {x => self.recibirDisparo()})
		//self.mover()
		self.moverseEnGrupo()
	}

	method decirVidas(){game.say(self, "Tengo " + vidas + " vidas.")} 
	/* 
	method configurarAcciones(){
		keyboard.up().onPressDo{self.decirVidas()}
		keyboard.down().onPressDo{self.recibirDisparo()}
	}	*/
	//method mover(){
	method moverseEnGrupo(){
		self.patrullarDerecha()
		//game.onTick(20000, "patrullar", {self.cambiarDireccion()})
		game.onTick(16500, "patrullar", {self.cambiarDireccion()})
	}
	method patrullarDerecha(){
		//game.onTick(1000,"Movimiento",{derecha.moverA(self)})
		game.onTick(1000,"Movimiento",{self.mover(derecha)})
	}
	method patrullarIzquierda(){
		//game.onTick(1000,"Movimiento",{izquierda.moverA(self)})
		game.onTick(1000,"Movimiento",{self.mover(izquierda)})
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
	override method disparar(dir){
		const disp = new Disparo(position = self.position().down(1))
		disp.serDisparadoPor(self, dir)
	}
}


object invasion{
	const property invasores = []
	method enemigoRandom() = 0.randomUpTo(invasores.size())
	method disparoRandom(){
		const enemigoQueDispare = invasores.get(self.enemigoRandom())
		if(invasores.contains(enemigoQueDispare)){
		enemigoQueDispare.disparar(abajo)}
	}

	//method atacar(){game.onTick(5000, "ataque", {self.disparoRandom()})}
	method atacar(){game.onTick(2000, "ataque", {self.disparoRandom()})}
	/* 
	method colocarFilaDeEnemigos(y){
		(1..12).forEach{x => self.aniadir(new Enemigo(position = game.at(x, y)))}
	}*/
	method colocarFilaDeEnemigos(y){ 
		(1..12).forEach{x => self.aniadir(new Enemigo(position = game.at(x, y) 
			
		))}

	}
	method aniadir(invasor){invasores.add(invasor)}
	method iniciarGrupo(){
		self.colocarFilaDeEnemigos(18)
		self.colocarFilaDeEnemigos(16)
		self.colocarFilaDeEnemigos(14)
		invasores.forEach({x=>x.iniciar()})
	}
	//method estaVacia(){invasores.isEmpty()}
}

class Disparo{
	//var property x
	//var property y=1
	//method serDisparadaPor(personaje){personaje.disparar()}
	var property image = "disparo.png"
	var property position 
	method puedeMoverA(dir) = dir.puedeMoverse(self)
	method mover(dir){
	if (self.puedeMoverA(dir)){
			dir.moverA(self)
		}else{
			self.detenerDisparo(dir)
		}
	}
	method colocarEn(pos){position = game.at(pos.x(), pos.y())}
	method detenerDisparo(dir){
		game.removeVisual(self)
		game.removeTickEvent("desplazar" + dir)
	}
	method serDisparadoPor(personaje, dir){
		game.addVisual(self)
		game.onTick(100, "desplazar" + dir, {self.mover(dir)})
		game.onCollideDo(self, {
		    	x => x.recibirDisparo()
		    	self.detenerDisparo(dir)
		   })
	}
	method recibirDisparo(){}
	
}



//MOVIMIENTOS
/*object arriba{
	method puedeMoverse(personaje) = personaje.position().y()+1 < game.height()
	method moverA(personaje){
		if (not self.puedeMoverse(personaje)){
			game.removeVisual(personaje)
			game.removeTickEvent("desplazarArriba") //ARREGLAR
		}else{
			personaje.position(personaje.position().up(1))
		}
	}
}*/

object arriba{
	method puedeMoverse(personaje) = personaje.position().y()+1 < game.height()
	method moverA(personaje){
		personaje.position(personaje.position().up(1))
	}
}

object abajo{
	method puedeMoverse(personaje) = personaje.position().y()-1 > -1
	method moverA(personaje){
		personaje.position( personaje.position().down(1))
	}
}

object derecha{
	method posDeReinicio() = game.at(0,0)
	method puedeMoverse(personaje) = personaje.position().x()+1 < game.width()
	method moverA(personaje){
		personaje.position( personaje.position().right(1))
	}
}

object izquierda{
	method posDeReinicio() = game.at(game.width()-1,0)
	method puedeMoverse(personaje) = personaje.position().x()-1 > -1
	method moverA(personaje){
		personaje.position( personaje.position().left(1))
	}
}
