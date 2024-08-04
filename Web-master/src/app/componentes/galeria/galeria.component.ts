import { Component, OnInit } from '@angular/core';
import { interval, Subscription } from 'rxjs';

@Component({
  selector: 'app-galeria',
  templateUrl: './galeria.component.html',
  styleUrls: ['./galeria.component.css']
})
export class GaleriaComponent implements OnInit {

  imagenes: Array<string>;
  imagenActual: any;
  subscription: Subscription;

  constructor() {
    this.setImagenActual(1);
   }

  ngOnInit(): void {
    this.imagenes = ['1f.jpeg', '2f.jpeg', '3f.jpeg'];
    const source = interval(2000);
    this.subscription = source.subscribe(val => this.setImagenActual(this.getRandomInt()));
  }

  setImagenActual(nro) {
    this.imagenActual = {
      'background-image': 'url("/assets/img/galeria/'+nro+'f.jpeg")',
      'background-repeat': 'no-repeat',
      'background-position': 'right',
      'height': '100%'
    };
    
  }

  getRandomInt() {
    let min=1;
    let max=4;
    min = Math.ceil(min);
    max = Math.floor(max);
    return Math.floor(Math.random() * (max - min) + min); //The maximum is exclusive and the minimum is inclusive
  }


}
