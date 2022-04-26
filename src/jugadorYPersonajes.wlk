import wollok.game.*
import main.*

// DINO JUGADOR

object dino {
	var activo = true
	var comioHuevo = false
	var position = game.at(2,1)
	var pasoActual = "dino1.png"
	method image() = pasoActual
	method position() = position
	method position(nueva){
		position = nueva
	}
	method iniciar(){
		activo = true
		game.onTick(200,"cambiarPasoDino", {self.cambiarPaso()})
	}
	method cambiarPaso() {
		if (pasoActual == "dino1.png") {
			pasoActual = "dino2.png"
		}
		else {
			pasoActual = "dino1.png"
		}
	}
	method comerHuevo() {
		comioHuevo = true
		game.say(self,"yummy!")
	}
	method saltar() {
		if (activo and position.y() == 1) {
			self.subir()
			game.schedule(velocidad*3,{self.bajar()})
		}
	}
	method dobleSalto() {
		if(activo and comioHuevo and position.y() == 1) {
			game.schedule(velocidad*3,{self.subir()})
			game.schedule(velocidad*4,{self.subir()})
			game.schedule(velocidad*10,{self.bajar()})
			game.schedule(velocidad*11,{self.bajar()})
			comioHuevo = false
		}
	}
	method subir(){
		position = position.up(1)
	}
	method bajar(){
		position = position.down(1)
	}
	method detener(){
		activo = false
	}
	method activo() = activo
}

// OBSTACULOS

object cactus {
	 
	const posicionInicial = game.at(game.width()-1,1)
	var position = posicionInicial

	method image() = "cactus.png"
	method position() = position
	
	method iniciar(){
		position = posicionInicial
		game.onTick(velocidad,"moverCactus",{self.mover()})
	}
	
	method mover(){
		position = position.left(1)
		if (position.x() == -1)
			position = posicionInicial
	}

	method efectoDeColisionar() {
		juego.terminar()
	}

	method terminar() {
		game.removeTickEvent("moverCactus")
	}
}

// DINO LARGO ENEMIGO

object dinoCuelloLargo {
	const posicionInicial = game.at(game.width(),1)
	var position = posicionInicial
	var activo = false
	
	method image() = "dinoCuelloLargoo.png"
	method position() = position
	
	method iniciar() {
		activo = true
		position = posicionInicial
		game.onTick(velocidad,"moverDinoCuelloLargo",{self.mover()})
	}
	method mover() {
		position = position.left(1)
		if (position.x() == -3){	//Si la llego al final, termina el tick
			self.terminar()
			activo = false
			if (dino.activo()) {	//Si dino sigue activo espera 10000ms y reinicia el tick
				game.schedule(10000,{self.iniciar()})
			}
		}
	}
	
	method terminar() {
		if (activo) {
			game.removeTickEvent("moverDinoCuelloLargo")
		}
	}
	
	method efectoDeColisionar(){
		juego.terminar()
	}
}

// DINO VOLADOR ALIADO

object dinoVolador {
	const posicionInicial = game.at(-2,2)
	var position = posicionInicial
	var pasoActual = "dinoVolador1.png"
	method image() = pasoActual
	method position() = position
	method iniciar() {
		position = posicionInicial
		game.onTick(velocidad*2,"moverDinoVolador",{self.mover()})
		game.onTick(150,"cambiarPasoDinoVolador",{self.cambiarPaso()})			
	}
	method mover() {
		position = position.right(1)
		if (position.x() == game.width()) {
			position = posicionInicial
			self.terminar()
			game.schedule(3000,{self.iniciar()})
		}
	}
	method subir() {
		position = position.up(1)
	}
	method cambiarPaso(){
		if (pasoActual == "dinoVolador1.png") {
			pasoActual = "dinoVolador2.png"
		}
		else {
			pasoActual = "dinoVolador1.png"
		}
	}	
	method respawn() {
		position = posicionInicial
	}
	method efectoDeColisionar(){
		game.schedule(velocidad*2.5,{self.subir()})
		game.schedule(velocidad*8,{huevo.iniciarCaida()})
	}
	method terminar() {
		game.removeTickEvent("moverDinoVolador")
		game.removeTickEvent("cambiarPasoDinoVolador")
		huevo.terminar()
	}
	
}

object huevo {
	var cayendo = false
	var moviendo = false
	const posicionInicial = game.at(5,3)
	var position = posicionInicial
	method image() = "huevo.png"
	method position() = position
	method iniciarCaida() {
		if (dino.activo()) {
			cayendo = true
			game.addVisual(self)
			game.onTick(velocidad,"huevoCayendo",{self.caer()})
			game.schedule(velocidad*2.5,{
				cayendo = false
				game.removeTickEvent("huevoCayendo")
				moviendo = true
				game.onTick(velocidad,"huevoMover",{self.mover()})
				}
			)
		}
	}
	method caer() {
		position = position.down(1)
	}
	method mover() {
		position = position.left(1)
	}
	method efectoDeColisionar() {
		dino.comerHuevo()
		self.terminar()
	}
	method terminar() {
		if (cayendo) {
			game.removeTickEvent("huevoCayendo")
			game.removeVisual(self)
			cayendo = false
		}
		else if (moviendo) {
			game.removeTickEvent("huevoMover")
			game.removeVisual(self)
			moviendo = false
		}
	}
}

// pozoDeAzufre

object pozoDeAzufre {
	
}