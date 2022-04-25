import wollok.game.*
import main.*

// DINO JUGADOR

object dino {
	var activo = true
	var position = game.at(1,1)
	var pasoActual = "dino1.png"
	
	method image() = pasoActual
	method position() = position
	
	method position(nueva){
		position = nueva
	}
	
	method iniciar(){
		activo = true
		game.onTick(200,"cambiarPaso", {self.cambiarPaso()})
	}
	
	method cambiarPaso() {
		if (pasoActual == "dino1.png") {
			pasoActual = "dino2.png"
		}
		else {
			pasoActual = "dino1.png"
		}
	}
	
	method saltar(){
		if(position.y() == 1) {
			self.subir()
			game.schedule(velocidad*3,{self.bajar()})
		}
	}
	
	method dobleSalto(){
		if (position.y() == 2) {
			game.schedule(velocidad*2,{self.subir()})
			game.schedule(velocidad*4,{self.subir()})
			game.schedule(velocidad*8,{self.bajar()})
			game.schedule(velocidad*12,{self.bajar()})
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
		game.removeTickEvent("cambiarPaso")
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

}

// DINO LARGO ENEMIGO

object dinoCuelloLargo {
	const posicionInicial = game.at(game.width()-1,1)
	var position = posicionInicial
	var estaCerca = false
	
	method image() = "dinoCuelloLargoo.png"
	method position() = position
	
	method iniciar() {
		position = posicionInicial
		estaCerca = false
		game.onTick(velocidad*3,"moverDinoCuelloLargo",{self.mover()})
	}
	method mover() {
		position = position.left(1)
		if (position.x() == -1){
			estaCerca = false
			game.schedule(velocidad*50,{self.respawn()})
		}
		if (position.x() <= 4){
			estaCerca = true
		}
	}
	
	method respawn(){
		position = posicionInicial
	}
	
	method estaCerca(){
		return estaCerca
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
		game.onTick(velocidad*3,"moverDinoVolador",{self.mover()})
		game.onTick(150,"cambiarPaso",{self.cambiarPaso()})
	}
	method mover() {
		if (dinoCuelloLargo.estaCerca()){
			position = position.right(1)
		}
		else {
			self.respawn()
		}
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
		dino.dobleSalto()
		game.say(dino,"rawr!")
	}
}

// pozoDeAzufre

object pozoDeAzufre {
	
}