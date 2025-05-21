{{flutter_js}}
{{flutter_build_config}}

document.body.style.height = '100%';
document.documentElement.style.height = '100%';
document.body.style.margin = '0px';
document.body.style.overflow = 'hidden';
document.documentElement.style.overflow = 'hidden';

const outerDiv = document.createElement('div');
outerDiv.style.width = '100%';
outerDiv.style.backgroundColor = 'black';
outerDiv.style.height = '100%';
const innerDiv = document.createElement('div');
innerDiv.id = 'flutter_host';
innerDiv.style.margin = '0 auto';
innerDiv.style.backgroundColor = 'black';
innerDiv.style.height = '100%';

outerDiv.appendChild(innerDiv);
document.body.appendChild(outerDiv);

function adjustDivWidth() {
  const windowWidth = window.innerWidth;
  const windowHeight = window.innerHeight;

  if (windowWidth > 430) {
    innerDiv.style.width = '430px';
    innerDiv.style.maxWidth = '430px';
  } else {
    innerDiv.style.width = '100%';
    innerDiv.style.maxWidth = '430px';
  }
}

adjustDivWidth();
window.addEventListener('resize', adjustDivWidth);

const target = document.getElementById('flutter_host');


_flutter.loader.load({
  onEntrypointLoaded: async function (engineInitializer) {
    const appRunner = await engineInitializer.initializeEngine({
      hostElement: target,
    });
    await appRunner.runApp();
    document.querySelector('meta[name="viewport"]').setAttribute('content', "width=device-width, initial-scale=1.0, viewport-fit=cover, user-scalable=no");
  }
});
