<?php

declare(strict_types=1);

namespace Tests\TailwindTheme;

use Doctrine\ORM\EntityManager;
use Sylius\Component\Core\Model\Channel;
use Symfony\Bundle\FrameworkBundle\Test\WebTestCase;

/**
 * @internal
 */
abstract class AbstractTest extends WebTestCase
{
    protected function getChannel(): Channel
    {
        /** @var EntityManager $manager */
        $manager = $this->getContainer()->get('doctrine')->getManager();

        return $manager->getRepository(Channel::class)->findOneBy([]);
    }

    protected function useNoneTheme(): void
    {
        $this->switchTheme(null);
    }

    protected function useTheme(): void
    {
        $this->switchTheme('agence-adeliom/sylius-tailwindcss-theme');
    }

    private function switchTheme(?string $theme): void
    {
        /** @var EntityManager $manager */
        $manager = $this->getContainer()->get('doctrine')->getManager();

        $channel = $manager->getRepository(Channel::class)->findOneBy([]);
        $channel->setThemeName($theme);
        $manager->flush();
    }
}
