export default {
  mounted() {
    const classMappings = {
      'correct': 'bg-green-600',
      'incorrect': 'bg-red-600',
      'partial': 'bg-yellow-600'
    };

    this.handleEvent('guess-reveal-animation', data => {
      const currentRow = document.getElementById(`input-row-${data.guess_row}`);
      const inputCells = Array.from(currentRow.children);
      const totalDelay = inputCells.length * 500;

      inputCells.forEach((inputCell, index) => {
        setTimeout(() => { // staggers color reveal
          // console.log(data)
          let letterGuessResult = data.letter_statuses[index];
          let backgroundColor = classMappings[letterGuessResult];
          let componentID = `#input-cell-${data.guess_row}-${index}`;
          this.pushEventTo(componentID, "cell_background_update", { background: backgroundColor });
        }, index * 500);
      });

      setTimeout(() => {
        Object.entries(data.comparison_results).forEach(([letter, guessResult]) => {
          let keycapComponentID = `#keycap-${letter}`;
          let backgroundColor = classMappings[guessResult];
          this.pushEventTo(keycapComponentID, "keycap_background", {background: backgroundColor});
        })
      }, totalDelay);
    });

  }
}