import wollok.game.*
import juego.*
import music.*
import portadas.*
import config.*
import visuales.*


class Nivel{
	var property image
	var property siguiente
	var resistenciaArbustos 
	
	method iniciar(){
		game.addVisualIn(self, game.at(0,0))
		jugador.iniciar()
		invasion.iniciarGrupo()
		invasion.atacar()
		const arbustos = new GrupoArbustos(vidas = resistenciaArbustos)
		arbustos.iniciar()
		}
}

const nivel1 = new Nivel(image="nivel1.png", siguiente=nivel2, resistenciaArbustos = 15)
const nivel2 = new Nivel(image="nivel2.png", siguiente=victoria, resistenciaArbustos = 10)