import { Controller } from "@hotwired/stimulus"
import Loader from "loader"

export default class extends Controller {
  static targets = [
    "searchInput", 
    "searchRandomize",
    "requestPlayerInput",
    "requestValueMessage",
    "requestSubmit"
  ]

  connect() {
    if(this.hasSearchInputTarget) {
      this.searchResultsContainer = document.getElementById("search-results-container");
      this.searchResults = document.getElementById("search-results")
      this.searchLoader = new Loader(this.searchResultsContainer)

      this.debouncedSearch = _.debounce(this.search.bind(this), 500)
      this.searchInputTarget.addEventListener("input", this.debouncedSearch)
    }

    if(this.hasSearchRandomizeTarget) {
      this.searchResultsContainer = document.getElementById("search-results-container");
      this.searchResults = document.getElementById("search-results")
      this.searchLoader = new Loader(this.searchResultsContainer)

      this.searchRandomizeTarget.addEventListener("click", this.fetchRandomRecords.bind(this))
    }

    if(this.hasRequestPlayerInputTarget) {
      this.requestPlayerInputTarget.addEventListener("input", this.validateRequestPlayerInput.bind(this))
    }
  }

  search() {
    this.searchLoader.show();
    const query = this.searchInputTarget.value;

    fetch(`/players/search?q=${encodeURIComponent(query)}`, {
      headers: { Accept: "application/json" }
    })
      .then(response => response.json())
      .then(data => {
        setTimeout(() => {
          this.searchResults.innerHTML = data.html;
          this.searchLoader.hide();
        }, 300);
      })
      .catch(err => {
        this.searchLoader.hide();
      })
  }

  fetchRandomRecords() {
    this.searchLoader.show();

    fetch(`${this.searchRandomizeTarget.dataset.url}`, {
      headers: { Accept: "application/json" }
    })
      .then(response => response.json())
      .then(data => {
        setTimeout(() => {
          this.searchResults.innerHTML = data.html;
          this.searchLoader.hide();
        }, 300);
      })
      .catch(err => {
        this.searchLoader.hide();
      })
  }

  validateRequestPlayerInput() {
    let inputValue = this.requestPlayerInputTarget.value
    let messageClassList = this.requestValueMessageTarget.classList
    let valid = /^[a-f\d]{24}$/i.test(inputValue);
    let currentMessageStatus;
  
    if (messageClassList.contains("valid")) {
      currentMessageStatus = "valid";
    } else if (messageClassList.contains("invalid")) {
      currentMessageStatus = "invalid";
    } else {
      currentMessageStatus = "empty";
    }
  
    if(inputValue && valid && currentMessageStatus != "valid") {
      messageClassList.add("opacity-0")

      setTimeout(() => {
        this.requestValueMessageTarget.textContent = "Valid player ID—you're good to go!"
        messageClassList.remove("text-red-500", "invalid", "opacity-0")
        messageClassList.add("text-green-500", "valid")
        this.requestSubmitTarget.classList.remove("opacity-50", "cursor-not-allowed")
        this.requestSubmitTarget.classList.add("cursor-pointer")
        this.requestSubmitTarget.disabled = false
      }, 200)
    } else if(inputValue && !valid && currentMessageStatus != "invalid") {
      messageClassList.add("opacity-0")

      setTimeout(() => {
        this.requestValueMessageTarget.textContent = "Invalid player ID"
        messageClassList.remove("text-green-500", "valid", "opacity-0")
        messageClassList.add("text-red-500", "invalid")
        this.requestSubmitTarget.classList.remove("cursor-pointer")
        this.requestSubmitTarget.classList.add("opacity-50", "cursor-not-allowed")
        this.requestSubmitTarget.disabled = true
      }, 200)
    } else if(!inputValue) {
      messageClassList.add("opacity-0")

      setTimeout(() => {
        this.requestValueMessageTarget.textContent = ""
        messageClassList.remove("valid", "invalid")
        this.requestSubmitTarget.classList.remove("cursor-pointer")
        this.requestSubmitTarget.classList.add("opacity-50", "cursor-not-allowed")
        this.requestSubmitTarget.disabled = true
      }, 200)
    }
  }
  
}
