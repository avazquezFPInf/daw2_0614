const theoryPages = [["00_Markdown.html", "0 · Markdown"], ["01_GitLocal.html", "1 · Fundamentos de Git local"], ["02_GestionRepositorio.html", "2 · Gestión diaria y .gitignore"], ["03_Ramas.html", "3 · Ramas y merge"], ["05_Colaboracion.html", "4 · Colaboración y conflictos"], ["04_GitHub.html", "5 · GitHub: cuenta y primer push"], ["06_GitHubFlujoRemoto.html", "6 · GitHub: clone, push, pull y PR"], ["07_VSCode.html", "7 · VS Code como interfaz Git"], ["08_PublicacionCI.html", "8 · GitHub Pages y Actions"]];
const practicePages = [["encargo-portfolio.html", "Encargo · Portfolio profesional"], ["00_Markdown.html#practica-perfil", "Crear perfil.md"], ["01_GitLocal.html#practica-git-local", "Versionar el perfil"], ["02_GestionRepositorio.html#practica-repositorio", "Organizar el repositorio"], ["03_Ramas.html#practica-ramas", "Ramas y merge"], ["05_Colaboracion.html#practica-conflictos", "Resolver un conflicto"], ["06_GitHubFlujoRemoto.html#practica-pull-request", "Crear una Pull Request"], ["07_VSCode.html#practica-vscode", "Flujo Git en VS Code"], ["08_PublicacionCI.html#practica-publicacion", "Publicar con GitHub Pages"]];
const activePage = document.body.dataset.active;
function navigationLinks(items, kind) {
  return items.map(([href, label]) => `<a class="sub nav-${kind}" href="${href}">${label}</a>`).join('');
}
const navigation = `<a href="../index.html">Inicio del módulo</a><a class="aea active" href="index.html">AEA1 · Git y documentación</a><span class="nav-label nav-label-theory">Teoría</span>${navigationLinks(theoryPages, 'theory')}<span class="nav-label nav-label-assignment">Prácticas y proyecto</span>${navigationLinks(practicePages, 'assignment')}<span class="nav-label">Continúa el módulo</span><a href="../AEA2/index.html">AEA2 · Arquitecturas web</a><a class="disabled" href="#">AEA3 · Servidores web</a><a class="disabled" href="#">AEA4 · Servidores de aplicaciones</a>`;
if (document.body.classList.contains('lesson-page')) {
  document.body.insertAdjacentHTML('afterbegin', `<button class="menu-button" type="button" aria-expanded="false" aria-controls="sidebar">Menú del módulo</button><aside id="sidebar" class="sidebar"><a class="brand" href="../index.html"><b>0614</b> DAW2</a><p class="sidebar-title">Despliegue de Aplicaciones Web</p><nav aria-label="Navegación del módulo">${navigation}</nav><p class="sidebar-footer">Curso 2026–2027<br>Institut Thos i Codina</p></aside>`);
} else {
  const existingNav = document.querySelector('.sidebar nav');
  if (existingNav) existingNav.innerHTML = navigation;
}
function updateCurrentLink() {
  const current = (activePage || 'index.html') + window.location.hash;
  document.querySelectorAll('.sidebar nav .sub').forEach(link => {
    const selected = link.getAttribute('href') === current;
    link.classList.toggle('active', selected);
    if (selected) link.setAttribute('aria-current', current.includes('#') ? 'location' : 'page');
    else link.removeAttribute('aria-current');
  });
}
updateCurrentLink();
window.addEventListener('hashchange', updateCurrentLink);
const button = document.querySelector('.menu-button');
const sidebar = document.querySelector('.sidebar');
if (button && sidebar) button.addEventListener('click', () => {
  const open = sidebar.classList.toggle('open');
  button.setAttribute('aria-expanded', String(open));
});
