object casa {
    var gastosMes = 0 
    var cuentasBancaria = null  
    var viveres = 0 
    var montoDeRepaciones= 0
    method gastosMes() {
      return gastosMes
    }
    method cuentasBancarias(_cuentas) {
      cuentasBancaria = _cuentas
    }
    method comprar(monto) {
      gastosMes = gastosMes + monto
      cuentasBancaria.extraer(monto)
    }
    method cambiarMes() {
      gastosMes = 0 
    }
    method vivere(_vivere) {
      viveres= _vivere
    }
    method viveres(){
      return viveres
    }
    method comprarViveres(calidad,porcentajeAComprar) {
      if (viveres + porcentajeAComprar < 1){ 
      cuentasBancaria.extraer(calidad * porcentajeAComprar)
      viveres = viveres + porcentajeAComprar 
    } else { 
      self.viveres()
    }
    }
    method romper(monto) {
      montoDeRepaciones= montoDeRepaciones + monto 
    }
    method hayViveresSuficientes() {
      return viveres > 0.4 
    }
    method hayQueHacerReparaciones() {
      return montoDeRepaciones > 0
    }
    method estaEnOrden() {
      return self.hayViveresSuficientes() && self.hayQueHacerReparaciones()
    }
    method montoDeRepaciones() {
      return montoDeRepaciones
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
}

object cuentaCombinada {
  var cuentaprimaria = cuentaCorriente
  var cuentaSecundaria = cuentaConGastos 
  method cuentaActiva(cuenta) {
    cuentaprimaria = cuenta
    cuentaSecundaria = self.obtenerCuentaSecundaria(cuenta)
  }
  method obtenerCuentaSecundaria(cuenta) {
    if (cuenta == cuentaCorriente)
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
      var saldoActual= cuentaprimaria.saldo()
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

