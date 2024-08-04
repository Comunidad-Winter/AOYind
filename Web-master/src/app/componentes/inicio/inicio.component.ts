import { Component, OnInit } from '@angular/core';


@Component({
  selector: 'app-inicio',
  templateUrl: './inicio.component.html',
  styleUrls: ['./inicio.component.css']
})
export class InicioComponent implements OnInit {


  mostrarInicio: boolean;
  mostrarEquipo: boolean;
  mostrarLicencia: boolean;

  constructor() { }

  ngOnInit(): void {
    this.mostrarInicio = true;
    this.mostrarEquipo = false;
    this.mostrarLicencia = false;
  }

  mostrarInicioFuncion(){
    this.mostrarInicio = true;
    this.mostrarEquipo = false;
    this.mostrarLicencia = false;
  }

  mostrarEquipoFuncion(){
    this.mostrarInicio = false;
    this.mostrarEquipo = true;
    this.mostrarLicencia = false;
  }

  mostrarLicenciaFuncion(){
    this.mostrarInicio = false;
    this.mostrarEquipo = false;
    this.mostrarLicencia = true;
  }

  irDiscord(){
    window.open('https://discord.gg/GcF9PcvXHW', "_blank");
  }
  
  irFacebook(){
    window.open('https://www.facebook.com/AoYind', "_blank");
  }

}
