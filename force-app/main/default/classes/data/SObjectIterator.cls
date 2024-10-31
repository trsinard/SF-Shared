public with sharing class SObjectIterator  implements Iterator<SObject>{

    private final List<SObject> items;
    private Integer currentIndex;

    public SObjectIterator(List<SObject> sobjects){
        this.items = sobjects;
        this.currentIndex = -1;
    }

    public Boolean hasNext(){
        return this.currentIndex + 1 < this.items.size();
    }

    public SObject next(){
        return hasNext() ? this.items[++this.currentIndex] : null;
    }

    public SObject peek() {
        return hasNext() ? this.items[this.currentIndex + 1] : null;
    }
}