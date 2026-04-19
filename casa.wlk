object casa {
    var gastosDelMes = 0 
    var cuentasBancaria = null  
    var viveres = 0 
    var montoDeRepaciones= 0
    var modoDeAhorro= minimoEIndispensable
    method modoDeAhorro(_modoDeAhorro) {
      modoDeAhorro= _modoDeAhorro
    }
    method modoDeAhorro() {
      return modoDeAhorro
    }
    method gastosDelMes() {
      return gastosDelMes
    }
    method cuentasBancarias(_cuentas) {
      cuentasBancaria = _cuentas
    }
    method comprar(monto) {
      gastosDelMes = gastosDelMes + monto
      cuentasBancaria.extraer(monto)
    }
    method cambiarMes() {
      gastosDelMes = 0 
      self.mantenimiento()
    }
    method mantenimiento() {
      modoDeAhorro.realizarMantenimiento()
    }
    method vivere(_vivere) {
      viveres= _vivere
    }
    method viveres(){
      return viveres
    }
    method comprarViveres(calidad,porcentajeAComprar) {
      if (viveres + porcentajeAComprar <= 100){ 
      viveres = viveres + porcentajeAComprar 
      gastosDelMes= gastosDelMes + calidad * porcentajeAComprar
      cuentasBancaria.extraer(calidad * porcentajeAComprar)
    } else { 
      self.error("no se pueden comprar mas viveres del necesario")
    }
    }
    method romper(monto) {
      montoDeRepaciones= montoDeRepaciones + monto 
    }
    method hayViveresSuficientes() {
      return viveres >= 40 
    }
    method hayQueHacerReparaciones() {
      return montoDeRepaciones > 0
    }
    method estaEnOrden() {
      return self.hayViveresSuficientes() and !self.hayQueHacerReparaciones()
    }
    method montoDeReparaciones() {
      return montoDeRepaciones
    }
    method montoDeReparaciones(_montoDeReparaciones){
      montoDeRepaciones = _montoDeReparaciones
    }

    method realizarReparaciones() {
      cuentasBancaria.extraer(montoDeRepaciones)
      gastosDelMes= gastosDelMes + montoDeRepaciones
      montoDeRepaciones = 0
    }
  
    }

object cuentaCorriente {
  var saldo = 0
  method saldo() {
    return saldo 
  }
  method depositar(monto) {
    saldo = saldo + monto
  } 
  method extraer(monto) {
    saldo = saldo - monto 
  }
  method isCorriente() {
    return true
  }
}

object cuentaConGastos {
  var saldo =0
  var operacion = 0
  method saldo() {
    return saldo 
  }
  method depositar(monto) {
    self.validarMonto(monto)
    saldo = saldo + monto - operacion
  }
  method extraer(monto) {
    saldo = saldo - monto 
  }
  method validarMonto(monto) {
    if (monto <= operacion) {
        self.error (" el monto es menor o igual al costo de la operacion ")
    }
  }
  method operacion(costo ) {
    operacion = costo
  }
  method operacion() {
    return operacion
  }
  method isCorriente() {
    return false
  }
}

object cuentaCombinada {
  var cuentaprimaria = cuentaCorriente
  var cuentaSecundaria = cuentaConGastos 
  method cuentaActiva(cuenta) {
    cuentaprimaria = cuenta
    cuentaSecundaria = self.obtenerCuentaSecundaria(cuenta)
  }
  method obtenerCuentaSecundaria(cuenta) {
    if (cuenta.isCorriente())
      return cuentaConGastos
    else
      return cuentaCorriente
  }
  method cuentaActual() {
    return cuentaprimaria
  }
  method saldo() {
    return 0.max(cuentaprimaria.saldo()) + 0.max(cuentaSecundaria.saldo())
  }
  method depositar(monto) {
    cuentaprimaria.depositar(monto) 
  }
  method extraer(monto) {
    self.validar(monto)
    if (cuentaprimaria.saldo() < monto ){
      const saldoActual= cuentaprimaria.saldo()
      cuentaprimaria.extraer(saldoActual)  
      cuentaSecundaria.extraer(monto - saldoActual)
    } else {
      cuentaprimaria.extraer(monto)
    }
  }
  method validar(monto){  
    if (cuentaprimaria.saldo() + cuentaSecundaria.saldo()< monto){
      self.error(" el monto es mayor al saldo total de las cuentas ")
    }
  }
}

object minimoEIndispensable {  
  var calidad= 0  
  
  method realizarMantenimiento() {
    if (!casa.hayViveresSuficientes()) {
       const viveresSuficientes = 40 - casa.viveres()
      casa.comprarViveres(calidad,viveresSuficientes)
    } else {
      self.error(" la cantidad de viveres es superior a lo necesario ")
    }
  }
  method calidad(_calidad) {
    calidad= _calidad 
  }
  method calidad() {
    return calidad 
  }
}


object full { 
 method realizarMantenimiento() {
    self.mantenimientoViveres()
    self.mantenimientoReparaciones()
 }
 method mantenimientoViveres() {
   if (casa.estaEnOrden()){
    casa.comprarViveres(5, 100 - casa.viveres())
   } else{ 
     casa.comprarViveres(5,40 - casa.viveres())
   }
 }
 method mantenimientoReparaciones() {
  if (cuentaCorriente.saldo()> casa.montoDeReparaciones()){
    casa.realizarReparaciones()
  } else {
    self.error("no hay suficiente dinero para realizar las reparaciones")
  }
 }
}





