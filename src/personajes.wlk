import wollok.game.*
import main.*
import jugador.*

//NECESARIOS PARA ENEMIGOS Y OBSTACULOS
//constantes: posicionInicial
//variables: posicionActual
//variables si tienen retardos: activo // animacion //
//metodos: image // position // iniciar // mover // terminar // efectoDeColisionar

object cactus {
	const posicionInicial = game.at(game.width(),1)
	var posicionActual = posicionInicial
	method image() {return "cactus.png"}
	method position() {return posicionActual}
	method iniciar() {
		posicionActual = posicionInicial
		game.onTick(velocidad,"moverCactus",{self.mover()})
	}
	method mover() {
		posicionActual = posicionActual.left(1)
		if (posicionActual.x() == -1) {
			posicionActual = posicionInicial
		}
	}
	method efectoDeColisionar() {
		juego.terminar()
	}
	method terminar() {
		game.removeTickEvent("moverCactus")
	}
}

object dinoCuelloLargo {
	const posicionInicial = game.at(game.width(),1)
	var posicionActual = posicionInicial
	var activo = false	//Necesario para no eliminar Tick si al morir dino no se inicio la instancia
	const animacion = "dinoCuelloLargoo.png"
	method image() {return animacion}
	method position() = posicionActual
	method iniciar() {
		posicionActual = posicionInicial
		game.schedule(velocidad+30000,{ //velocidad se podria reemplazar por un numero random?
			if (dino.estaVivo()) {	//Si al terminar la espera el dino esta vivio, inicia el tick de dinoCuelloLargo
				activo = true
				game.onTick(velocidad,"moverDinoCuelloLargo",{self.mover()})
				//agregar tick inicio animacion self.animar()
			}
		})
	}
	method mover() {
		posicionActual = posicionActual.left(1)
		if (posicionActual.x() == -3) {
			self.terminar()
			activo = false
			self.iniciar() //Reinicia la instancia
		}
	}
	method efectoDeColisionar() {
		juego.terminar()
	}
	method terminar() {
		if (activo) {
			game.removeTickEvent("moverDinoCuelloLargo")
			//agregar tick fin animacion
		}
	}
}

object dinoVolador { //REQUIERE QUE TERMINAR QUITE EL TICK EXTERNAMENTE!!!
	const posicionInicial = game.at(-2,2)
	var posicionActual = posicionInicial
	var activo	= false //nuevo
	var animacion = "dinoVolador1.png"
	method image() {return animacion}
	method position() {return posicionActual}
	method iniciar() {
		posicionActual = posicionInicial
		game.schedule(velocidad+10000,{
			if(dino.estaVivo()) {//nuevo
				activo = true //nuevo
				game.onTick(velocidad*2,"moverDinoVolador",{self.mover()})
				game.onTick(150,"animarDinoVolador",{self.animar()})
			}
		})
	}
	method mover() {//se cambio
		posicionActual = posicionActual.right(1)
		if (posicionActual.x() == game.width()) {
			self.terminar()
			activo = false //nuevo
			self.iniciar() //cambio
		}
	}
	method subir() {
		posicionActual = posicionActual.up(1)
	}
	method animar() {
		if (animacion == "dinoVolador1.png") {
			animacion = "dinoVolador2.png"
		}
		else {
			animacion = "dinoVolador1.png"
		}
	}
	method efectoDeColisionar() { //comprobar si vive dino o no? ESTE OBJETO NO TERMINA AL COLISIONAR, PERO DEBE FINALIZAR EN ALGUN MOMENTO
		game.schedule(velocidad*2.5,{self.subir()})
		game.schedule(velocidad*8,{huevo.iniciarCaida()})
	}
	method terminar() {
		if (activo) {
			game.removeTickEvent("moverDinoVolador")
			game.removeTickEvent("animarDinoVolador")	
		}
	}
}

object huevo {
	const posicionInicial = game.at(5,3)
	var posicionActual = posicionInicial
	var cayendo = false
	var moviendose = false
	method image() {return "huevo.png"}
	method position() {return posicionActual}
	method iniciarCaida() {
		if (dino.estaVivo()) {//necesario?
			posicionActual = posicionInicial
			game.addVisual(self)
			cayendo = true
			game.onTick(velocidad,"huevoCaer",{self.caer()})
			game.schedule(velocidad*2.5,{
				cayendo = false
				game.removeTickEvent("huevoCaer")
				moviendose = true
				game.onTick(velocidad,"huevoMover",{self.mover()})
			})
		}
	}
	method caer() {posicionActual = posicionActual.down(1)}
	method mover() {
		posicionActual = posicionActual.left(1)
		if (posicionActual.x() == -1) {
			self.terminar()
		}
	}
	method efectoDeColisionar() {
		dino.comerHuevo()
		self.terminar()
	}
	method terminar() {
		if (cayendo) {
			game.removeTickEvent("huevoCaer")
			game.removeVisual(self)
			cayendo = false
		}
		else if (moviendose) {
			game.removeTickEvent("huevoMover")
			game.removeVisual(self)
			moviendose = false
		}
	}
}