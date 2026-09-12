<?php

namespace App\Controller;

use App\Entity\Memo;
use App\Form\MemoType;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;

class MainController extends AbstractController
{
    public function index(EntityManagerInterface $entityManager): Response
    {
        $items = $entityManager
            ->getRepository(Memo::class)
            ->findAll();

        return $this->render('index.html.twig', [
            'name' => '名前',
            'items' => $items,
        ]);
    }

    public function new(
        Request $request,
        EntityManagerInterface $entityManager
    ): Response {
        $memo = new Memo();

        $form = $this->createForm(MemoType::class, $memo);

        $form->handleRequest($request);

        if ($form->isSubmitted() && $form->isValid()) {
            $entityManager->persist($memo);
            $entityManager->flush();

            return $this->redirectToRoute('main');
        }

        return $this->render('memo/new.html.twig', [
            'form' => $form,
        ]);
    }

    public function delete(
        int $id,
        EntityManagerInterface $entityManager
    ): Response {
        $memo = $entityManager
            ->getRepository(Memo::class)
            ->find($id);

        if (!$memo) {
            throw $this->createNotFoundException('Memo not found');
        }

        $entityManager->remove($memo);
        $entityManager->flush();

        return $this->redirectToRoute('main');
    }

}
