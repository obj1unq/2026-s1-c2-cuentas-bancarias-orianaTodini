object casa {
    var gastosMes = 0 
    var cuentasBancaria = null  
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
    if (cuenta == cuentaCorriente){
      cuentaprimaria = cuentaCorriente
      cuentaSecundaria = cuentaConGastos
    } else {
      cuentaprimaria = cuentaConGastos
      cuentaSecundaria = cuentaCorriente
    }
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

