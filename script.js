const nav = document.querySelector('.nav-links');
const navMenuBtn = document.querySelector('.nav-btn');


const navToggleFunc = function(){nav.classList.toggle('open');}

navMenuBtn.addEventListener('click',navToggleFunc);

