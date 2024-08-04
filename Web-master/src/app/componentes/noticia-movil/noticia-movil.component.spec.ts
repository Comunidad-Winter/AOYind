import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { NoticiaMovilComponent } from './noticia-movil.component';

describe('NoticiaMovilComponent', () => {
  let component: NoticiaMovilComponent;
  let fixture: ComponentFixture<NoticiaMovilComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ NoticiaMovilComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(NoticiaMovilComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
