import { ComponentFixture, TestBed } from '@angular/core/testing';
import { TaskFormComponent } from './task-form.component';
import { ReactiveFormsModule } from '@angular/forms';
import { TaskService } from '../../services/task.service';
import { of } from 'rxjs';
import { Router } from '@angular/router';

describe('TaskFormComponent', () => {
  let component: TaskFormComponent;
  let fixture: ComponentFixture<TaskFormComponent>;
  let mockTaskService: jasmine.SpyObj<TaskService>;
  let mockRouter: jasmine.SpyObj<Router>;

  beforeEach(() => {
    mockTaskService = jasmine.createSpyObj<TaskService>('TaskService', ['createTask']);
    mockRouter = jasmine.createSpyObj<Router>('Router', ['navigate']);

    TestBed.configureTestingModule({
      imports: [ReactiveFormsModule],
      declarations: [TaskFormComponent],
      providers: [
        { provide: TaskService, useValue: mockTaskService },
        { provide: Router, useValue: mockRouter }
      ]
    }).compileComponents();

    fixture = TestBed.createComponent(TaskFormComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create the component', () => {
    expect(component).toBeTruthy();
  });

  it('should call createTask on form submit', () => {
    component.taskForm.setValue({
      nom: 'Nouvelle tâche',
      description: 'Description ici',
      statut: 'à faire'
    });

    mockTaskService.createTask.and.returnValue(of({
      id: 1,
      nom: 'Nouvelle tâche',
      description: 'Description ici',
      statut: 'à faire',
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString()
    }));

    component.onSubmit();

    expect(mockTaskService.createTask).toHaveBeenCalled();
    expect(mockRouter.navigate).toHaveBeenCalledWith(['/tasks']);
  });
});
