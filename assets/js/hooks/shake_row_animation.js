export default {
  mounted() { 
    this.handleEvent('shake-row', data => { // data is the payload
      const inputRowId = `input-row-${data.row}`;
      const inputRow = document.getElementById(inputRowId); // get element with that id from the dom

      const animationEndHandler = () => { // called when animation on element ends
        inputRow.classList.remove('shake-element');
        inputRow.removeEventListener('animationend', animationEndHandler);
      };

      inputRow.classList.add('shake-element');
      inputRow.addEventListener('animationend', animationEndHandler);
    });

  }
}