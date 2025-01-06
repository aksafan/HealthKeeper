import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "select",
    "referenceRange",
    "unit",
    "referenceRangeId",
    "unitField",
  ]

  connect() {
    if (this.selectTarget.value) {
      this.updateReferenceRange()
    }
  }

  async updateReferenceRange() {
    try {
      const biomarkerId = this.selectTarget.value
      if (!biomarkerId) {
        this.resetDisplays()
        return
      }

      const response = await fetch(
        `/biomarkers/${biomarkerId}/reference_ranges`
      )
      if (!response.ok) throw new Error("Network response was not ok")

      const ranges = await response.json()
      if (ranges.length > 0) {
        const range = ranges[0] // Take first range for now
        const minValue = range.min_value ?? "?"
        const maxValue = range.max_value ?? "?"
        this.referenceRangeTarget.textContent = `${minValue} - ${maxValue}`
        this.unitTarget.textContent = range.unit || "-"
        this.referenceRangeIdTarget.value = range.id
        this.unitFieldTarget.value = range.unit || ""
      } else {
        this.resetDisplays()
      }
    } catch (error) {
      console.error("Error fetching reference ranges:", error)
      this.resetDisplays()
    }
  }

  resetDisplays() {
    this.referenceRangeTarget.textContent = "Select biomarker first"
    this.unitTarget.textContent = "-"
    this.referenceRangeIdTarget.value = ""
    this.unitFieldTarget.value = ""
  }
}
