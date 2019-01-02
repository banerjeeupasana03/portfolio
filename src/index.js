import _ from 'lodash';

function component() {
  let element = document.createElement('div');
  element.innerHTML = _.join(['Hello', 'webpack'], ' '); // <div>Hello webpack</div>
  return element;
}

document.body.appendChild(component());
