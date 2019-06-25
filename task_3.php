<?php

class MyClass implements SeekableIterator
{
    private $handle;

    private $position;

    public function __construct($filePath)
    {
        if (!file_exists($filePath)) {
            throw new Exception('File not found.');
            die();
        }

        $handle = fopen($filePath, 'r');
        if ($handle === false) {
            throw new Exception('File open failed.');
            die();
        }

        $this->handle = $handle;
        $this->position = 1;
    }

    public function current()
    {
        $line = 1;
        fseek($this->handle, 0);
        while (($current = fgets($this->handle)) && ($line < $this->position)) {
            $line++;
        }
        return $current ?: 'not found, eof';
    }

    public function next()
    {
        $this->position++;
    }

    public function key()
    {
        return (int)$this->position;
    }

    public function valid()
    {
        return !feof($this->handle);
    }

    public function rewind()
    {
        $this->position = 1;
    }

    public function seek($position)
    {
        $this->position = $position;
    }
}