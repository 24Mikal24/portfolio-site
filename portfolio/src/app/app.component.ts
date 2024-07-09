import { Component, OnInit } from '@angular/core';
import { Router, RouterLink, RouterLinkActive, RouterOutlet, RoutesRecognized } from '@angular/router';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [RouterOutlet, RouterLink, RouterLinkActive],
  templateUrl: './app.component.html',
  styleUrl: './app.component.css'
})
export class AppComponent implements OnInit {
  pageTitle: any;

  constructor(private router: Router) {}
  
  ngOnInit(): void {
    this.router.events.subscribe(data => {
      if (data instanceof RoutesRecognized) {
        this.pageTitle = data.state.root.firstChild!.data['pageTitle'];
      }
    });
  }
}
