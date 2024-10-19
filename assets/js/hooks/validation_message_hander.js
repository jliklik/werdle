export default {
  mounted() {
    this.handleEvent('guess-validation-text', data => {
    const gameContainer = document.getElementById('game-container');
    if (!gameContainer || !data.message) {
      return; // Exit if gameContainer doesn't exist or message is undefined
    }

    const textBox = document.createElement('div');
    textBox.textContent = data.message;
    textBox.classList.add(
      'py-3',
      'px-3',
      'rounded-md',
      'absolute',
      'transition-opacity',
      'duration-500',
      'opacity-0',
      'bg-slate-100',
      'text-gray-900',
      'font-bold',
      'text-sm',
      '-translate-y-7',
      'animate-none'
    );
    gameContainer.appendChild(textBox);

    setTimeout(() => {
      textBox.style.opacity = '1';
    }, 100);

    setTimeout(() => {
      fadeOutAndRemove(textBox);
    }, 5000);
  });

  }
};

function fadeOutAndRemove(element) {
  element.style.opacity = '0';
  setTimeout(() => {
    element.remove();
  }, 250);
}