import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { EquipoMovilComponent } from './equipo-movil.component';

describe('EquipoMovilComponent', () => {
  let component: EquipoMovilComponent;
  let fixture: ComponentFixture<EquipoMovilComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ EquipoMovilComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(EquipoMovilComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
